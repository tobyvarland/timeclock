class CreatePeriods < ActiveRecord::Migration[6.0]

  def change

    create_table :periods do |t|
      t.date        :starts_on, null: false
      t.date        :ends_on,   null: false
      t.boolean     :is_closed, default: false
      t.timestamps
    end

  end

end