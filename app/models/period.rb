class Period < ApplicationRecord

  # Enable soft deletes.
  acts_as_paranoid

  # Associations.
  has_many  :punches,
            dependent: :destroy
  has_many  :users,
            through: :punches

  # Validations.
  validates :starts_on,
            presence: true,
            uniqueness: { case_sensitive: false }
  validates :ends_on,
            presence: true,
            uniqueness: { case_sensitive: false }
  validate  :period_ending_date_must_be_saturday,
            :period_starting_date_must_be_sunday
  
  # Callbacks.
  before_validation :set_starts_on

  # Scopes.
  scope :chronological, -> { order(:ends_on) }
  scope :reverse_chronological, -> { order(ends_on: :desc) }
  scope :not_closed, -> { where("is_closed IS FALSE") }

  # Instance methods.

  # Ensures ends_on date is a Saturday.
  def period_ending_date_must_be_saturday
    if self.ends_on.present? && self.ends_on.wday != 6
      errors.add(:ends_on, "must be a Saturday")
    end
  end

  # Ensures starts_on date is a Sunday.
  def period_starting_date_must_be_sunday
    if self.starts_on.present? && self.starts_on.wday != 0
      errors.add(:ends_on, "must be a Sunday")
    end
  end

  # Sets starting date based on ending date.
  def set_starts_on
    if self.ends_on.blank?
      self.starts_on = nil
    else
      self.starts_on = self.ends_on.prev_occurring(:sunday)
    end
  end

  # Returns period description.
  def description
    "Week of #{self.starts_on.strftime("%m/%d/%Y")} &ndash; #{self.ends_on.strftime("%m/%d/%Y")}".html_safe
  end

  # Class methods.

  # Returns period for current week.
  def self.current
    return self.find_for(DateTime.now)
  end

  # Returns period for last week.
  def self.last_week
    return self.weeks_ago(1)
  end

  # Returns period for given number of weeks ago.
  def self.weeks_ago(weeks)
    return self.find_for(DateTime.now - weeks.week)
  end

  # Finds period for given date.
  def self.find_for(date)

    # Find period ending date for given date.
    period_end = nil
    if date.wday == 6
      period_end = date.to_date
    else
      period_end = date.to_date.next_occurring(:saturday)
    end

    # Find/create period and return.
    return self.find_or_create_by(ends_on: period_end)

  end

end