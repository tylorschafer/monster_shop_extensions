require 'rails_helper'

describe Coupon do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_uniqueness_of :name}
    it {should validate_numericality_of :rate}
    it {should validate_numericality_of :chance}
  end

  describe 'relationships' do
    it {should have_many :orders}
    it {should belong_to :merchant}
  end
end
