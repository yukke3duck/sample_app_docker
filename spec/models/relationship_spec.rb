require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:follower) { FactoryBot.create(:user) }
  let(:followed) { FactoryBot.create(:user) }
  let(:relationship) { FactoryBot.build(:relationship, follower:, followed:) }

  it 'is valid' do
    expect(relationship).to be_valid
  end

  it 'is invalid without follower_id' do
    relationship.follower_id = nil
    relationship.valid?
    expect(relationship.errors[:follower_id]).to include("can't be blank")
  end

  it 'is invalid without followed_id' do
    relationship.followed_id = nil
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include("can't be blank")
  end
end
