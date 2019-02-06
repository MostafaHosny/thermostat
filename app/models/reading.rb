class Reading < ApplicationRecord
  belongs_to :thermostat
  acts_as_sequenced scope: :thermostat_id, column: :number

  # validations
  validates :thermostat_id, presence: true
  validates :temperature, presence: true, numericality: true
  validates :humidity, presence: true, numericality: true
  validates :battery_charge, presence: true, numericality: true
end
