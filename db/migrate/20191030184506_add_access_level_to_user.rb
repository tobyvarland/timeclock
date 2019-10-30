class AddAccessLevelToUser < ActiveRecord::Migration[6.0]

  def change
    add_column :users, :access_level, :integer, default: 1, null: false
  end

end