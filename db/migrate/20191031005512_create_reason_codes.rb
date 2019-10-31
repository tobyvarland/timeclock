class CreateReasonCodes < ActiveRecord::Migration[6.0]

  def change

    create_table :reason_codes do |t|
      t.string      :code,            null: false
      t.boolean     :requires_notes,  default: false
      t.timestamps
    end

  end

end