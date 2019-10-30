class AddDeletedAtToPunch < ActiveRecord::Migration[6.0]
  
  def change
    add_column :punches, :deleted_at, :datetime
    add_index :punches, :deleted_at
  end

end