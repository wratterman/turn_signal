class Model < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :make
  has_many :vehicles
end
