class User < ApplicationRecord

  # Enumerations.
  enum status: {
    clocked_in: "clocked_in",
    clocked_out: "clocked_out",
    on_break: "on_break"
  }

  # Associations.
  has_many  :punches

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

  # Scopes.
  scope :by_number, -> { order(:employee_number) }
  scope :on_the_clock, -> { where("status != 'clocked_out'") }
  
  # Instance methods.

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
      when "end_break"
        self.status = :clocked_in
        self.secondary_status_timestamp = nil
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