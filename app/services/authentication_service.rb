class AuthenticationService
  attr_reader :headers

  def initialize(headers)
    @headers = headers
  end

  def perform
    thermostat
  end

private

  def thermostat
    Thermostat.find_by(household_token: token)
  end

  def token
    headers["Authorization"]&.split(" ")&.last
  end
end
