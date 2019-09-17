require 'rails_helper'

describe 'Merchants can edit coupons' do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @sue = @dog_shop.users.create(name: 'Sue', email: 'sue@email.com', password: 'sue', password_confirmation: 'sue', role: 3)

    visit '/login'

    fill_in 'Email', with: @sue.email
    fill_in 'Password', with: @sue.password

    within '#login-form' do
      click_on 'Log In'
    end
  end
  it 'there is a link to an edit form from merchant coupon index' do
    coupon_1 = create(:coupon, merchant: @dog_shop)
    coupon_2 = create(:coupon, merchant: @dog_shop)

    visit merchant_coupons_path

    within "#coupon-#{coupon_1.id}" do
      expect(page).to have_link('Edit Coupon')
      click_link 'Edit Coupon'
    end

    expect(current_path).to eq(edit_coupon_path(coupon_1))

    name = 'MegaDeal'
    type = 'percent'
    rate = 10

    fill_in 'Name', with: name
    fill_in 'Coupon type', with: type
    fill_in 'Rate', with: rate
    click_on 'Update Coupon'

    expect(current_path).to eq(merchant_coupons_path)

    within "#coupon-#{coupon_1.id}" do
      expect(page).to have_content(name)
      expect(page).to have_content('percent')
      expect(page).to have_content("%10")
    end
  end
end
