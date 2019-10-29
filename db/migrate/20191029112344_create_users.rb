class CreateUsers < ActiveRecord::Migration[6.0]

  def change

    create_table :users do |t|
      t.integer     :employee_number, null: false
      t.string      :name,            null: false
      t.string      :pin,             null: false,  limit: 4
      t.timestamps
    end

  end

end