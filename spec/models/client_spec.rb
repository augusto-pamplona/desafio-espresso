require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:company_id) }
    it { should validate_presence_of(:erp_key) }
    it { should validate_presence_of(:erp_secret) }
  end

  describe 'associations' do
    it { should have_many(:bills) }
    it { should have_many(:webhooks) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:client)).to be_valid
    end
  end
end
