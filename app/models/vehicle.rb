class Vehicle < ApplicationRecord
  belongs_to :make
  belongs_to :model
end
