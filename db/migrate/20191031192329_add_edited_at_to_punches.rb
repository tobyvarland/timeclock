class AddEditedAtToPunches < ActiveRecord::Migration[6.0]

  def change
    add_column :punches, :edited_at, :datetime, default: nil
  end

end