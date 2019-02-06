class CreateThermostats < ActiveRecord::Migration[5.2]
  def change
    create_table :thermostats, id: :uuid do |t|
      t.text :household_token
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
