class V1::ReadingsController < V1::BaseController
  before_action :reading_service, only: :create
  before_action :set_reading, only: :show

  def create
    if reading_service.valid?
      reading_service.save

      render json: reading_service.reading, status: :created
    else
      render json: { errors: reading_service.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    raise ActiveRecord::RecordNotFound unless @reading

    render json: @reading
  end

  def stats
    render json: current_thermostat.stats
  end

private

  def set_reading
    @reading =
      current_thermostat.redis_readings.find { |reading| reading[:id] == params[:id] } ||
      current_thermostat.readings.find(params[:id])
  end

  def reading_params
    params.fetch(:reading, {}).permit(:temperature, :humidity, :battery_charge)
  end

  def reading_service
    @reading_service ||= ReadingService.new(thermostat: current_thermostat, reading_params: reading_params)
  end
end
