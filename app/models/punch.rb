class Punch < ApplicationRecord

  # Enumerations.
  enum punch_type: {
    start_work: "start_work",
    end_work: "end_work",
    start_break: "start_break",
    end_break: "end_break",
    notes: "notes"
  }

  # Associations.
  belongs_to  :user

  # Validations.
  validates :punch_type,
            presence: true
  validates :punch_at,
            presence: true
  
  # Callbacks.
  after_save    :update_user_status
  after_destroy :update_user_status

  # Scopes.
  scope :chronological, -> { order(:punch_at) }
  scope :reverse_chronological, -> { order(punch_at: :desc) }
  scope :current_week, -> { where("DATE(punch_at) >= ? AND DATE(punch_at) <= ?", Punch.current_period_start, Punch.current_period_end) }

  # Instance methods.

  # Updates user status after punch saved.
  def update_user_status
    self.user.update_status unless self.punch_type == :notes
  end

  # Class methods.

  # Returns period ending date for current week.
  def self.current_period_end
    today = Date.today
    if today.wday == 6
      return today
    else
      return today.next_occurring(:saturday)
    end
  end

  # Periods period beginning date for current week.
  def self.current_period_start
    today = Date.today
    if today.wday == 0
      return today
    else
      return today.prev_occurring(:sunday)
    end
  end

end