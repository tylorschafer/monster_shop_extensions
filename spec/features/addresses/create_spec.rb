require 'rails_helper'

describe 'new order creation' do
  before :each do
    @user = User.create(name: 'Tylor', password: 'password', email: 'email@email.com')
    @street = '234 A st'
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

      fill_in 'Street', with: @street
      fill_in 'City', with: @city
      fill_in 'State', with: @state
      fill_in 'Zip', with: @zip
      click_on 'Create Address'

      expect(page).to have_content('Which address would you like to ship to?')
      expect(page).to have_content('Home')
      expect(page).to have_content(@street)
      expect(page).to have_content(@city)
      expect(page).to have_content(@state)
      expect(page).to have_content(@zip)
      expect(page).to have_link('Select')
      expect(page).to_not have_link('Create Order')

      click_on 'Select'

      expect(page).to have_content('Your order will be shipped to:')
      expect(page).to have_content('Home')
      expect(page).to have_content(@street)
      expect(page).to have_content(@city)
      expect(page).to have_content(@state)
      expect(page).to have_content(@zip)
      expect(page).to have_link('Select a Different Address')

      expect(page).to have_link('Create Order')

      save_and_open_page

      click_link 'Select a Different Address'

      expect(page).to have_content('Which address would you like to ship to?')
    end
    it 'an error message will be displayed if the new address form is not completed' do
      click_on 'Create Address'

      expect(page).to have_content("Street can't be blank, City can't be blank, State can't be blank, and Zip can't be blank")
    end

    it 'Add a new address from profile' do
      visit '/profile'

      click_link 'Add New Shipping Address'

      expect(current_path).to eq(new_address_path)

      fill_in 'Nickname', with: 'Work'
      fill_in 'Street', with: @street
      fill_in 'City', with: @city
      fill_in 'State', with: @state
      fill_in 'Zip', with: @zip
      click_on 'Create Address'

      expect(current_path).to eq('/profile')

      new_address = Address.last

      expect(new_address.nickname).to eq('Work')
      expect(new_address.street).to eq(@street)
      expect(new_address.city).to eq(@city)
      expect(new_address.state).to eq(@state)
      expect(new_address.zip).to eq(@zip)
    end
  end
end
