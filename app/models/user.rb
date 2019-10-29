class User < ApplicationRecord

  # Validators.
  validates :employee_number,
            presence: true,
            uniqueness: { case_sensitive: false },
            numericality: { only_integer: true, greater_than: 0 }
  validates :name,
            presence: true
  validates :pin,
            presence: true,
            format: { with: /\A[0-9]{4}\z/ }

end