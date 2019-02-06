FactoryBot.define do
  factory :reading do
    number { 1 }
    thermostat
    temperature { 1.5 }
    humidity { 1.5 }
    battery_charge { 1.5 }
  end
end
