FactoryGirl.define do
  factory :make do
    sequence :name do |i|
      "Car Brand#{i}"
    end
  end
end
