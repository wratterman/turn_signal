require 'rails_helper'

RSpec.describe Make, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "associations" do
    it { is_expected.to have_many(:models) }
    it { is_expected.to have_many(:vehicles) }
  end
end
