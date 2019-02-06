class ReadingService
  attr_reader :thermostat, :reading_params

  delegate :errors, :valid?, to: :reading

  def initialize(thermostat:, reading_params:)
    @thermostat = thermostat
    @reading_params = reading_params.merge(id: uuid)
  end

  def save
    add_to_redis
    CreateReadingJob.perform_later(thermostat.id, reading_params)
  end

  def add_to_redis # rubocop:disable Metrics/AbcSize
    redis_readings << reading

    thermostat.temperature.bulk_set(min: min_temp, max: max_temp, avg: average(:temperature))
    thermostat.humidity.bulk_set(min: min_humidity, max: max_humidity, avg: average(:humidity))
    thermostat.battery_charge.bulk_set(min: min_charge, max: max_charge, avg: average(:battery_charge))
  end

  def reading
    @reading ||= Reading.new(reading_params.merge(thermostat_id: thermostat.id, number: number_of_readings.increment))
  end

private

  def number_of_readings
    thermostat.no_of_readings
  end

  def uuid
    SecureRandom.uuid
  end

  def redis_readings
    @redis_readings ||= thermostat.redis_readings
  end

  def min_temp # rubocop:disable Metrics/AbcSize
    return reading.temperature if thermostat.temperature[:min].to_f > reading.temperature || thermostat.temperature[:min].blank?

    thermostat.temperature[:min].to_f
  end

  def max_temp
    return reading.temperature if thermostat.temperature[:max].to_f < reading.temperature

    thermostat.temperature[:max].to_f
  end

  def min_humidity # rubocop:disable Metrics/AbcSize
    return reading.humidity if thermostat.humidity[:min].to_f > reading.humidity || thermostat.humidity[:min].blank?

    thermostat.humidity[:min].to_f
  end

  def max_humidity
    return reading.humidity if thermostat.humidity[:max].to_f < reading.humidity

    thermostat.humidity[:max].to_f
  end

  def min_charge # rubocop:disable Metrics/AbcSize
    return reading.battery_charge if thermostat.battery_charge[:min].to_f > reading.battery_charge || thermostat.battery_charge[:min].blank?

    thermostat.battery_charge[:min].to_f
  end

  def max_charge
    return reading.battery_charge if thermostat.battery_charge[:max].to_f < reading.battery_charge

    thermostat.battery_charge[:max].to_f
  end

  def average(attribute_name)
    total = thermostat_readings.map(&:"#{attribute_name}").push(reading.temperature)
    total.sum.fdiv(total.size + 1)
  end

  def thermostat_readings
    @thermostat_readings ||= thermostat.readings
  end
end
