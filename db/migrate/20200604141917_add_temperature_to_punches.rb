class AddTemperatureToPunches < ActiveRecord::Migration[6.0]
  def change
    add_column :punches, :temperature, :float, null: true, default: nil
  end
end
