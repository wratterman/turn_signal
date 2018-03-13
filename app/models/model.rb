class Model < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :make
  # Assuming makes have some sort of patent surrounding a model name
  has_many :vehicles
end
