require 'rails_helper'

RSpec.describe Make, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
  # The "deleted_at" field will be nil by default
  # It is only on the DELETE request that a timestamp will be updated

  describe "associations" do
    it { is_expected.to have_many(:models) }
    it { is_expected.to have_many(:vehicles) }
  end
end
