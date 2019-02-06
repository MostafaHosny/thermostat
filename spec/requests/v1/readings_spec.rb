require "rails_helper"

RSpec.describe V1::ReadingsController, type: :request do
  let(:thermostat) { create(:thermostat) }
  let(:reading) { create(:reading, thermostat: thermostat) }
  let(:json_response) { JSON.parse(response.body) }

  describe "GET #show" do
    it "returns http success" do
      get v1_reading_path(reading), headers: { Authorization: "Bearer #{thermostat.household_token}" }

      expect(response).to have_http_status(:success)
      expect(json_response["reading"]["id"]).to eq(reading.id)
    end

    it "returns not found" do
      get v1_reading_path("wrong"), headers: { Authorization: "Bearer #{thermostat.household_token}" }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    let(:reading_params) { build(:reading).attributes }

    it "returns http success" do
      post v1_readings_path, headers: { Authorization: "Bearer #{thermostat.household_token}" }, params: { reading: reading_params }

      expect(response).to have_http_status(:created)
      expect(json_response).to have_key("reading")
    end

    it "returns validations error" do
      post v1_readings_path, headers: { Authorization: "Bearer #{thermostat.household_token}" }, params: {}

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET #stats" do
    let!(:min_reading) { create(:reading, temperature: 1, humidity: 1, battery_charge: 1, thermostat: thermostat) }
    let!(:max_reading) { create(:reading, temperature: 4, humidity: 4, battery_charge: 4, thermostat: thermostat) }
    let(:avg) { (min_reading.temperature + max_reading.temperature) / 2 }

    before do
      get stats_v1_readings_path, headers: { Authorization: "Bearer #{thermostat.household_token}" }
    end

    it "returns min values" do
      expect(json_response["temperature"]["min"]).to eq(min_reading.temperature)
      expect(json_response["humidity"]["min"]).to eq(min_reading.humidity)
      expect(json_response["battery_charge"]["min"]).to eq(min_reading.battery_charge)
    end

    it "returns max values" do
      get stats_v1_readings_path, headers: { Authorization: "Bearer #{thermostat.household_token}" }

      expect(json_response["temperature"]["max"]).to eq(max_reading.temperature)
      expect(json_response["humidity"]["max"]).to eq(max_reading.humidity)
      expect(json_response["battery_charge"]["max"]).to eq(max_reading.battery_charge)
    end

    it "returns average values" do
      get stats_v1_readings_path, headers: { Authorization: "Bearer #{thermostat.household_token}" }

      expect(json_response["temperature"]["avg"]).to eq(avg)
      expect(json_response["humidity"]["avg"]).to eq(avg)
      expect(json_response["battery_charge"]["avg"]).to eq(avg)
    end
  end

  describe ".unauthorized" do
    it "returns unauthorized without token" do
      get v1_reading_path(reading)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
