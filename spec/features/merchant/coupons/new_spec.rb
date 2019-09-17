require 'rails_helper'

describe 'Merchants can create coupons' do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @sue = @dog_shop.users.create(name: 'Sue', email: 'sue@email.com', password: 'sue', password_confirmation: 'sue', role: 3)

    visit '/login'

    fill_in 'Email', with: @sue.email
    fill_in 'Password', with: @sue.password

    within '#login-form' do
      click_on 'Log In'
    end
  end

  it "A merchant can create coupons from the coupon tab" do
    visit merchant_coupons_path

    expect(page).to have_link('Create a new Coupon')

    click_link 'Create a new Coupon'

    expect(current_path).to eq(new_coupon_path)


    name = 'MegaDeal'
    type = 'percent'
    rate = 10

    fill_in 'Name', with: name
    fill_in 'Coupon type', with: type
    fill_in 'Rate', with: rate
    click_on 'Create Coupon'

    expect(current_path).to eq(merchant_coupons_path)

    expect(page).to have_content(name)
    expect(page).to have_content('percent')
    expect(page).to have_content("%10")
  end
end
