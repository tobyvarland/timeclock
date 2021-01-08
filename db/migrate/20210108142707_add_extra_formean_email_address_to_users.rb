class AddExtraFormeanEmailAddressToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :foreman_email, :string, default: nil
  end
end
