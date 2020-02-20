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
    notes: "notes"
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

  # Instance methods.

  # Requires notes if reason code requires notes.
  def require_notes_if_reason_code
    return if self.reason_code.blank?
    if self.notes.blank? && self.reason_code.requires_notes
      errors.add(:notes, "can't be blank for this reason code")
    end
  end

  # Update edited_at if record is edited.
  def update_edit_timestamp
    if self.edited_by_id_changed? || self.notes_changed? || self.reason_code_id_changed?
      self.edited_at = DateTime.now.localtime.strftime("%Y-%m-%d %H:%M:%S")
    end
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