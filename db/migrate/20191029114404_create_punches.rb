class CreatePunches < ActiveRecord::Migration[6.0]

  def change

    create_table :punches do |t|
      t.references  :user,        null: false,  foreign_key: true
      t.string      :punch_type,  null: false
      t.datetime    :punch_at,    null: false
      t.timestamps
    end

  end

end