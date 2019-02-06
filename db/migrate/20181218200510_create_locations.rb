class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    enable_extension "pgcrypto"
    create_table :locations do |t|
      t.decimal :lat
      t.decimal :lng

      t.timestamps
    end
  end
end
