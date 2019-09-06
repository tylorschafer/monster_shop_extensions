require 'rails_helper'

describe MerchantUser do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should belong_to :user }
  end
end
