class ReasonCode < ApplicationRecord

  # Validations.
  validates :code,
            presence: true,
            uniqueness: { case_sensitive: false }

end