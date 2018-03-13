require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:make) }
    it { is_expected.to belong_to(:model) }
  end
  # The "deleted_at" field will be nil by default
  # It is only on the DELETE request that a timestamp will be updated
end
