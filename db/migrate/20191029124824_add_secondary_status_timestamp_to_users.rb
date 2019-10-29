class AddSecondaryStatusTimestampToUsers < ActiveRecord::Migration[6.0]

  def change

    change_table :users do |t|
      t.datetime    :secondary_status_timestamp,  default: nil
    end

  end

end