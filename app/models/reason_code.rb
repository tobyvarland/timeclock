class ReasonCode < ApplicationRecord

  # Associations.
  has_many  :punches,
            dependent: :restrict_with_error

  # Validations.
  validates :code,
            presence: true,
            uniqueness: { case_sensitive: false }

end