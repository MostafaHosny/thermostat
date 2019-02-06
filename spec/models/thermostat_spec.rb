require "rails_helper"

RSpec.describe Thermostat, type: :model do
  it { is_expected.to have_many(:readings) }
  it { is_expected.to belong_to(:location) }

  it { is_expected.to validate_presence_of(:location) }

  let(:thermostat) { create(:thermostat) }
end
