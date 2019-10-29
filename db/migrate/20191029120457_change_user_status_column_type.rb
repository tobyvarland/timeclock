class ChangeUserStatusColumnType < ActiveRecord::Migration[6.0]

  def up
    execute <<-SQL
        ALTER TABLE users MODIFY status enum('clocked_in', 'clocked_out', 'on_break');
    SQL
  end

  def down
    change_column :users, :status, :string
  end

end
