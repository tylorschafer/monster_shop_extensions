require 'rails_helper'

describe 'Merchants can delete coupons' do
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
  it 'the delete link will delete a coupon' do
    coupon_1 = create(:coupon, merchant: @dog_shop)
    coupon_2 = create(:coupon, merchant: @dog_shop)

    visit merchant_coupons_path

    within "#coupon-#{coupon_1.id}" do
      expect(page).to have_link('Delete Coupon')
      click_link 'Delete Coupon'
    end

    expect(page).to_not have_content(coupon_1.name)
    expect(page).to_not have_content(coupon_1.rate)

    user = create(:user)
    order = create(:order, user: user, address: user.addresses[0], coupon: coupon_2)

    visit merchant_coupons_path

    expect(page).to_not have_link('Update Coupon')
    expect(page).to_not have_link('Delete Coupon')
    expect(page).to have_content('Coupons used on user orders cannot be modified')
  end
end
