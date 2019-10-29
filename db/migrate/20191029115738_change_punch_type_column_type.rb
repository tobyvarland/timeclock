class ChangePunchTypeColumnType < ActiveRecord::Migration[6.0]

  def up
    execute <<-SQL
        ALTER TABLE punches MODIFY punch_type enum('start_work', 'end_work', 'start_break', 'end_break', 'notes');
    SQL
  end

  def down
    change_column :punches, :punch_type, :string
  end

end