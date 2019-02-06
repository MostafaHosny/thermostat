class V1::ReadingSerializer < ActiveModel::Serializer
  attributes :id, :number, :thermostat_id, :temperature, :humidity, :battery_charge
end
