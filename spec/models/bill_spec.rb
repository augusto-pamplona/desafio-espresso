# == Schema Information
#
# Table name: bills
#
#  id            :bigint           not null, primary key
#  account_code  :string
#  category_code :string
#  client_code   :string
#  cost          :float
#  due_date      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :bigint           not null
#
# Indexes
#
#  index_bills_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:client) }
    it { should validate_presence_of(:client_code) }
    it { should validate_presence_of(:category_code) }
    it { should validate_presence_of(:account_code) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:cost) }
    it { should validate_numericality_of(:cost).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should belong_to(:client) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:bill)).to be_valid
    end
  end
end
