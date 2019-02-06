class V1::BaseController < ApplicationController
  include ExceptionHandler
  include Response
  before_action :authorize!

private

  def authorize!
    return if current_thermostat

    render json: { error: "invalid token" }, status: :unauthorized unless current_thermostat
  end

  def current_thermostat
    @current_thermostat ||= AuthenticationService.new(request.headers).perform
  end
end
