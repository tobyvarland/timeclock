class AddExtraFormeanFieldToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_aux_foreman, :bool, null: false, default: false
  end
end
