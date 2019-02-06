class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings, id: :uuid do |t|
      t.integer :number
      t.uuid :thermostat_id, foreign_key: true
      t.float :temperature
      t.float :humidity
      t.float :battery_charge

      t.timestamps
      t.index :thermostat_id
    end
  end
end
