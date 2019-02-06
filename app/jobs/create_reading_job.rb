class CreateReadingJob < ApplicationJob
  queue_as :default

  def perform(thermostat_id, reading_params)
    Reading.create!(reading_params.merge(thermostat_id: thermostat_id))
  rescue => exception
    logger.error exception.message
  end
end
