require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it 'responds to #email' do
    user = FactoryGirl.create(:user, email: 'hey@yahoo.com')
    expect(user.email).to eq('hey@yahoo.com')
  end

  it 'can create users through .from_omniauth' do
    auth = {
      provider: 'fake',
      uid: 100000,
      info: {email: 'fake@yahoo.com'}
    }
    user = User.from_omniauth(auth)
    expect(user).to eq(User.last)
  end

  it 'has a timezone' do
    user = FactoryGirl.create(:user)
    expect(user).to respond_to(:time_zone)
  end

  it 'has many budgets' do
    user = FactoryGirl.create(:user)
    expect(user).to respond_to(:budgets)
  end

end
