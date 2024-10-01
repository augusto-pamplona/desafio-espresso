# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  kind       :integer
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_webhooks_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
require 'rails_helper'

RSpec.describe Webhook, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:client) }
    it { should validate_presence_of(:url) }
    it { should allow_value("https://example.com").for(:url) }
    it { should_not allow_value("invalid_url").for(:url).with_message("must be a valid URL") }
    it { should validate_presence_of(:kind) }
    it { should define_enum_for(:kind).with_values(default: 0, client: 1, bill: 2, refund: 3) }
  end

  describe 'associations' do
    it { should belong_to(:client) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:webhook)).to be_valid
    end
  end
end
