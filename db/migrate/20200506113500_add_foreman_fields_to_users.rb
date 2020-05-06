class AddForemanFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :foreman_allowed, :boolean, null: false, default: false
    add_column :users, :is_foreman, :boolean, null: false, default: false
    add_column :users, :foreman_priority, :integer, null: false, default: 0
  end
end
