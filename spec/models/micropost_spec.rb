require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.build(:micropost, user:) }

  it 'is valid' do
    expect(micropost).to be_valid
  end

  it 'is invalid without user id' do
    micropost.user = nil
    micropost.valid?
    expect(micropost.errors[:user]).to include('must exist')
  end

  it 'is invalid without content' do
    micropost.content = ' '
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
  end

  it 'is invalid with content more than 141 characters' do
    micropost.content = 'a' * 141
    micropost.valid?
    expect(micropost.errors[:content]).to include('is too long (maximum is 140 characters)')
  end

  it 'does something' do
    30.times.each { FactoryBot.create(:micropost) }
    micropost = FactoryBot.create(:micropost, :most_recent)
    expect(micropost).to eq(Micropost.first)
  end
end
