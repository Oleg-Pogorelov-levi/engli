
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation test' do

    it 'username is valid' do
      user = User.new(username: '')
      user.valid?
      user.errors[:username].should_not be_empty
    end

    it "email is valid" do
      user = User.new(email: '')
      user.valid?
      user.errors[:email].should_not be_empty
    end

  end
end