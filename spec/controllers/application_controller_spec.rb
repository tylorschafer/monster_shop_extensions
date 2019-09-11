require 'rails_helper'

describe 'application controller methods' do
  it "current_merchant_admin" do
    merchant = create(:merchant)
    merchant_user = create(:user, role: 3, merchant_id: merchant.id)
    item = create(:item, merchant_id: merchant.id)

    visit '/login'

    fill_in 'Email', with: merchant_user.email
    fill_in 'Password', with: merchant_user.password

    within '#login-form' do
      click_on 'Log In'
    end

    visit "/merchants/#{merchant.id}/edit"

    expect(page).to have_field('Name')
  end
end
