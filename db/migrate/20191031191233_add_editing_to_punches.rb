class AddEditingToPunches < ActiveRecord::Migration[6.0]

  def change
    add_reference :punches, :edited_by,   default: nil, foreign_key:  { to_table: 'users' }
    add_reference :punches, :reason_code, default: nil, foreign_key: true
    add_column    :punches, :notes,       :text
  end

end