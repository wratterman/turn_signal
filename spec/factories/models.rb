FactoryGirl.define do
  factory :model do
    sequence :name do |i|
      "Car Model#{i}"
    end
    make
  end
end
