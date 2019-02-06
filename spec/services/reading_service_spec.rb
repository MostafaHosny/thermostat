require "rails_helper"

RSpec.describe ReadingService do
  include ActiveJob::TestHelper

  let(:thermostat) { create(:thermostat) }
  let(:reading_params) { build(:reading, thermostat: nil).attributes }

  let(:service) { ReadingService.new(thermostat: thermostat, reading_params: reading_params) }
  subject { service }

  it "expect to be valid" do
    expect(subject.valid?).to be_truthy
    expect(subject.errors).to be_empty
  end

  it "expect to save the object to redis" do
    expect { subject.save }.to change { thermostat.redis_readings.values.size }.by(1)
    expect(thermostat.temperature.values.present?).to be_truthy
    expect(thermostat.humidity.values.present?).to be_truthy
    expect(thermostat.battery_charge.values.present?).to be_truthy
  end

  it "enqueu an reading job" do
    expect { subject.save }.to have_enqueued_job(CreateReadingJob)
  end
end
