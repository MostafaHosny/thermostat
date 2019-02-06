class Thermostat < ApplicationRecord
  include Redis::Objects

  # redis attributes per object
  list :redis_readings, marshal: true, maxlength: 50 # after 50 readings in redis list the oldest one will deleted
  counter :no_of_readings
  hash_key :temperature
  hash_key :humidity
  hash_key :battery_charge

  belongs_to :location
  has_many :readings
  has_secure_token :household_token

  validates :location, presence: true

  def stats
    {
      temperature: temperature.all.presence || attribute_stats(:temperature),
      humidity: humidity.all.presence || attribute_stats(:humidity),
      battery_charge: battery_charge.all.presence || attribute_stats(:battery_charge)
    }.to_json
  end

private

  def attribute_stats(attribute_name)
    {
      min: readings.map(&:"#{attribute_name}").min,
      max: readings.map(&:"#{attribute_name}").max,
      avg: readings.map(&:"#{attribute_name}").sum.fdiv(readings.count)
    }
  end
end
