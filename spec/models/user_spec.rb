require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of(:email)}
    it {should validate_uniqueness_of(:email)}
    it {should validate_confirmation_of(:password)}
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:address)}
    it {should validate_presence_of(:city)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zip)}
  end
  describe "relationships" do
    it {should have_many :orders}
    it {should have_many :merchant_users}
    it {should have_many(:merchants).through(:merchant_users)}
  end
end
