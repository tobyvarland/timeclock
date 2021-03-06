class Punch < ApplicationRecord

  # Enable soft deletes.
  acts_as_paranoid

  # Enable change tracking.
  has_paper_trail

  # Enumerations.
  enum punch_type: {
    start_work: "start_work",
    end_work: "end_work",
    start_break: "start_break",
    end_break: "end_break",
    notes: "notes",
    remote_start: "remote_start",
    remote_end: "remote_end",
  }

  # Associations.
  belongs_to  :user
  belongs_to  :period
  belongs_to  :editor,
              class_name: "User",
              foreign_key: "edited_by_id",
              optional: true
  belongs_to  :reason_code,
              optional: true

  # Validations.
  validates :punch_type,
            presence: true
  validates :punch_at,
            presence: true
  validate  :require_open_period
  validate  :require_notes_if_reason_code
  validate  :require_labor_if_end_work
  validate  :require_temperature_if_start_work
  validates  :temperature,
             numericality: { greater_than_or_equal_to: 95, less_than_or_equal_to: 99.5 },
             allow_nil: true
  
  # Callbacks.
  after_save        :update_user_status
  after_destroy     :update_user_status
  before_validation :set_period
  before_save       :update_edit_timestamp

  # Scopes.
  scope :chronological, -> { order(:punch_at) }
  scope :reverse_chronological, -> { order(punch_at: :desc) }
  scope :current_week, -> { where("period_id = ?", Period.current.id) }
  scope :previous_week, -> { where("period_id = ?", Period.last_week.id) }
  scope :weeks_ago, ->(weeks) { where("period_id = ?", Period.weeks_ago(weeks).id) unless weeks.blank? }
  scope :in_period, ->(id) { where("period_id = ?", id) unless id.blank? }
  scope :for_user, ->(id) { where("user_id = ?", id) unless id.blank? }
  scope :in_open_period, -> { joins(:period).where(periods: { is_closed: false }) }
  scope :with_reason_code, ->(id) { where("reason_code_id = ?", id) unless id.blank? }
  scope :with_temperature, -> { where("temperature IS NOT NULL") }

  # Instance methods.

  # Requires temperature if starting work.
  def require_temperature_if_start_work
    return unless self.punch_type == "start_work"
    if self.temperature.blank?
      errors.add(:base, "You must enter your temperature when starting work.")
    end
  end

  # Requires labor entry on System i if clocking out.
  def require_labor_if_end_work
    return unless self.punch_type == "end_work"
    return if self.period.blank?
    return if self.user.blank?
    return if self.user.employee_number >= 600
    return unless self.reason_code.blank?
    target_time = self.punch_at - 6.minutes
    shift = nil
    case target_time.hour
    when 0..6
      shift = 2
      target_time -= 8.hours
    when 7..18
      shift = 1
    when 19..23
      shift = 2
    end
    unless self.user.labor_entered? target_time, shift
      errors.add(:base, "Not allowed to clock out without entering labor on the System i for #{shift}#{shift.ordinal} shift on #{target_time.strftime("%m/%d")}")
    end
  end

  # Requires notes if reason code requires notes.
  def require_notes_if_reason_code
    return if self.reason_code.blank?
    if self.notes.blank? && self.reason_code.requires_notes
      errors.add(:notes, "can't be blank for this reason code")
    end
  end

  # Update edited_at if record is edited.
  def update_edit_timestamp
    return if self.edited_by_id.blank? && self.notes.blank? && self.reason_code_id.blank?
    #if self.edited_by_id_changed? || self.notes_changed? || self.reason_code_id_changed?
      self.edited_at = DateTime.current
    #end
  end

  # Ensures period is open.
  def require_open_period
    return if self.period.blank?
    if self.period.is_closed
      errors.add(:period, "is already closed")
    end
  end

  # Sets period.
  def set_period
    return if self.punch_at.blank?
    self.period = Period.find_for(self.punch_at)
  end

  # Description message.
  def description
    action = nil
    case self.punch_type
    when "start_work"
      action = "Clocked in"
    when "end_work"
      action = "Clocked out"
    when "start_break"
      action = "Started break"
    when "end_break"
      action = "Ended break"
    when "remote_start"
      action = "Clocked in remotely"
    when "remote_end"
      action = "Clocked out remotely"
    else
      return nil
    end
    return "#{self.user.name}: #{action} @ #{self.punch_at.strftime("%I:%M%P")}"
  end

  # Updates user status after punch saved.
  def update_user_status
    self.user.update_status unless self.punch_type == :notes
  end

end