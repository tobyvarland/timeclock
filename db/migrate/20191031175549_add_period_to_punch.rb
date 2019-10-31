class AddPeriodToPunch < ActiveRecord::Migration[6.0]

  def change
    add_reference :punches, :period, null: false, foreign_key: true
  end
  
end