class AddStatusAndTimestampToUsers < ActiveRecord::Migration[6.0]

  def change

    change_table :users do |t|
      t.string      :status,            default: nil
      t.datetime    :status_timestamp,  default: nil
    end

  end

end