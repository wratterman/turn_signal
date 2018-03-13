require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:make) }
    it { is_expected.to belong_to(:model) }
  end
end
