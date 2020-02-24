class User < ApplicationRecord

  # Enable soft deletes.
  acts_as_paranoid

  # Enumerations.
  enum status: {
    clocked_in: "clocked_in",
    clocked_out: "clocked_out",
    on_break: "on_break"
  }
  enum access_level: {
    employee: 1,
    supervisor: 2,
    admin: 3
  }

  # Associations.
  has_many  :punches,
            dependent: :destroy
  has_many  :edited_punches,
            class_name: "Punch",
            foreign_key: "edited_by_id",
            dependent: :nullify

  # Validations.
  validates :employee_number,
            presence: true,
            uniqueness: { case_sensitive: false },
            numericality: { only_integer: true, greater_than: 0 }
  validates :name,
            presence: true
  validates :pin,
            presence: true,
            format: { with: /\A[0-9]{4}\z/ }
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-z]+\z/ }

  # Scopes.
  scope :by_number, -> { order(:employee_number) }
  scope :on_the_clock, -> { where("status != 'clocked_out'") }
  scope :without_salary, -> { where.not("(employee_number >= 700 AND employee_number <= 799)").where.not("(employee_number >= 900 AND employee_number <= 999)") }
  
  # Callbacks.
  after_create  :update_status
  
  # Instance methods.

  # Checks labor entry on System i for given date and shift.
  def labor_entered?(date, shift)
    uri = URI.parse("http://as400api.varland.com/v1/labor_entry?employee=#{self.employee_number}&shift=#{shift}&date=#{date.strftime("%Y-%m-%d")}")
    puts uri
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    return true unless response.code.to_s == '200'
    result = JSON.parse(response.body)
    return result
  end

  # Authenticates via System i.
  def ibm_authenticate(password)
    uri = URI.parse("http://as400api.varland.com/v1/as400_auth")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = "username=#{self.username}&password=#{password}"
    response = http.request(request)
    return false unless response.code.to_s == '200'
    result = JSON.parse(response.body)
    return result
  end

  # Updates user status. Intended to be called whenever a punch for this user is saved.
  def update_status

    # Find last non-notes punch.
    punch = self.punches.not_notes.reverse_chronological.first

    # Set status.
    unless punch.blank?
      case punch.punch_type
      when "start_work"
        self.status = :clocked_in
        self.status_timestamp = punch.punch_at
        self.secondary_status_timestamp = nil
      when "end_work"
        self.status = :clocked_out
        self.status_timestamp = nil
        self.secondary_status_timestamp = nil
      when "start_break"
        self.status = :on_break
        self.secondary_status_timestamp = punch.punch_at
        if self.status_timestamp.blank?
          start_work = self.punches.not_notes.where(punch_type: :start_work).reverse_chronological.first
          self.status_timestamp = start_work.punch_at
        end
      when "end_break"
        self.status = :clocked_in
        self.secondary_status_timestamp = nil
        if self.status_timestamp.blank?
          start_work = self.punches.not_notes.where(punch_type: :start_work).reverse_chronological.first
          self.status_timestamp = start_work.punch_at
        end
      end
    else
      self.status = :clocked_out
      self.status_timestamp = nil
      self.secondary_status_timestamp = nil
    end

    # Save user.
    self.save

  end

end