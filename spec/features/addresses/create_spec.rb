require 'rails_helper'

describe 'new order creation' do
  before :each do
    @user = User.create(name: 'Tylor', password: 'password', email: 'email@email.com')
    @address = '234 A st'
    @city = 'Wonderland'
    @state = 'CA'
    @zip = 90345
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    visit '/login'

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    within '#login-form' do
      click_on 'Log In'
    end

    visit "/items/#{@tire.id}"
    click_on "Add To Cart"

    visit '/cart'

    click_on 'Checkout'
  end

  describe 'the user will be prompted to create a new address if they have no address' do
    it 'is saved into the addresses database and given a default nickname of Home if nickname is not included' do

      expect(page).to have_content('Create an Address for your order:')
      expect(page).to_not have_link('Create Order')

      fill_in 'Address', with: @address
      fill_in 'City', with: @city
      fill_in 'State', with: @state
      fill_in 'Zip', with: @zip
      click_on 'Create Address'

      new_address = Address.last

      expect(page).to have_content('Which address would you like to ship to?')
      expect(page).to have_content('Home')
      expect(page).to have_content(@address)
      expect(page).to have_content(@city)
      expect(page).to have_content(@state)
      expect(page).to have_content(@zip)
      expect(page).to have_link('Select')
      expect(page).to_not have_link('Create Order')

      click_on 'Select'

      expect(page).to have_content('Your order will be shipped to:')
      expect(page).to have_content('Home')
      expect(page).to have_content(@address)
      expect(page).to have_content(@city)
      expect(page).to have_content(@state)
      expect(page).to have_content(@zip)
      expect(page).to_not have_link('Select')

      expect(page).to have_link('Create Order')
    end
  end
end
