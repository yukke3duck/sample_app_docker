require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:followed_user) { FactoryBot.create(:user) }

  it { expect(user).to be_valid }

  it 'is invalid without name' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without email' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with too long name' do
    user = FactoryBot.build(:user, name: 'a' * 51)
    user.valid?
    expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid with too long email' do
    user = FactoryBot.build(:user, email: "#{'a' * 244}@example.com")
    user.valid?
    expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it 'is accepted with valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    aggregate_failures do
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid, "#{valid_address.inspect} should be valid"
      end
    end
  end

  it 'is rejected with invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com
                           foo@bar..com]
    aggregate_failures do
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end
  end

  it 'is invalid with a duplicate email' do
    user.save
    duplicated_user = user.dup
    duplicated_user.valid?
    expect(duplicated_user.errors[:email]).to include('has already been taken')
  end

  it 'is saved as lowercase in email addresses' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    user = FactoryBot.create(:user, email: mixed_case_email)
    expect(user.email).to eq mixed_case_email.downcase
  end

  it 'is invalid withput password' do
    user = FactoryBot.build(:user, password: ' ' * 6)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid without minimum length password' do
    user = FactoryBot.build(:user, password: 'a' * 5)
    user.valid?
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end

  it { expect(user.authenticated?(:remember, '')).to be false }

  it 'is destroyed with associated microposts' do
    user.save
    FactoryBot.create(:micropost, user:)
    expect do
      user.destroy
    end.to change(Micropost, :count).by(-1)
  end

  it 'does not have following user' do
    user.save
    expect(user.following?(followed_user)).to be false
  end

  it 'follows other user' do
    user.save
    user.follow(followed_user)
    expect(user.following?(followed_user)).to be true
    expect(followed_user.followers.include?(user)).to be true
  end

  it 'does not follow itself' do
    user.save
    user.follow(user)
    expect(user.following?(user)).to be false
  end

  describe 'see the feed' do
    let(:unfollowed_user) { FactoryBot.create(:user) }
    before do
      user.save
      user.follow(followed_user)

      10.times.each do
        FactoryBot.create(:micropost, user:)
        FactoryBot.create(:micropost, user: followed_user)
        FactoryBot.create(:micropost, user: unfollowed_user)
      end
    end

    it 'see the post by following user' do
      followed_user.microposts.each do |post_following|
        expect(user.feed.include?(post_following)).to be true
      end
    end

    it 'see the post by itself' do
      user.microposts.each do |post_self|
        expect(user.feed.include?(post_self)).to be true
        expect(user.feed.distinct).to eq(user.feed)
      end
    end

    it 'does not see the post by unfollowing' do
      unfollowed_user.microposts.each do |post_unfollowed|
        expect(user.feed.include?(post_unfollowed)).to be false
      end
    end
  end
end
