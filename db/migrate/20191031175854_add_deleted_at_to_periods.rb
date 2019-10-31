class AddDeletedAtToPeriods < ActiveRecord::Migration[6.0]
  
  def change
    add_column :periods, :deleted_at, :datetime
  end

end