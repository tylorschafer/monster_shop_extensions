require 'rails_helper'

describe 'merchant coupon index' do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @sue = @dog_shop.users.create(name: 'Sue', email: 'sue@email.com', password: 'sue', password_confirmation: 'sue', role: 3)
    @coupon_1 = @dog_shop.coupons.create!(name: 'Mega Deal 900', coupon_type: 1, rate: 10)
    @coupon_2 = @dog_shop.coupons.create!(name: 'Little Deal 100', coupon_type: 2, rate: 15)

    visit '/login'

    fill_in 'Email', with: @sue.email
    fill_in 'Password', with: @sue.password

    within '#login-form' do
      click_on 'Log In'
    end
  end

  it 'shows all current coupons' do
    visit merchant_coupons_path

    expect(page).to have_content(@coupon_1.name)
    expect(page).to have_content(@coupon_1.coupon_type)
    expect(page).to have_content("%10")
    expect(page).to have_content(@coupon_1.status)

    expect(page).to have_content(@coupon_2.name)
    expect(page).to have_content(@coupon_2.coupon_type)
    expect(page).to have_content("$15")
    expect(page).to have_content(@coupon_2.status)
  end
end
