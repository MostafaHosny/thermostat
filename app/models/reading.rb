class Reading < ApplicationRecord
  belongs_to :thermostat
  acts_as_sequenced scope: :thermostat_id, column: :number
end
