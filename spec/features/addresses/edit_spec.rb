require 'rails_helper'

describe 'User profile page' do
  before :each do
    @user = User.create(name: 'Tylor', password: 'password', email: 'email@email.com')
    @address_1 = create(:address, user_id: @user.id)
    @address_2 = create(:address, user_id: @user.id)
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
  end

  it 'Users can edit their addressess from their profile ' do
    visit '/profile'

    within "#address-#{@address_1.id}" do
      expect(page).to have_content(@address_1.nickname)
      expect(page).to have_content(@address_1.street)
      expect(page).to have_content(@address_1.city)
      expect(page).to have_content(@address_1.state)
      expect(page).to have_content(@address_1.zip)
      click_on 'Edit Address'
    end

    expect(current_path).to eq(edit_address_path(@address_1.id))

    nickname = 'Work'
    street = '123 Fake Streek'
    city = 'Apple Valley'
    state = 'MN'
    zip = 55024

    fill_in 'Nickname', with: nickname
    fill_in 'Street', with: street
    fill_in 'City', with: city
    fill_in 'State', with: state
    fill_in 'Zip', with: zip
    click_button 'Update Address'

    expect(current_path).to eq('/profile')

    within "#address-#{@address_1.id}" do
      expect(page).to have_content(nickname)
      expect(page).to have_content(street)
      expect(page).to have_content(city)
      expect(page).to have_content(state)
      expect(page).to have_content(zip)
    end
  end

  it 'A flash message will display an error if a field is left blank' do
    visit '/profile'

    within "#address-#{@address_1.id}" do
      click_on 'Edit Address'
    end

    fill_in 'Nickname', with: ''
    fill_in 'Street', with: ''
    fill_in 'City', with: ''
    fill_in 'State', with: ''
    fill_in 'Zip', with: ''
    click_button 'Update Address'

    expect(current_path).to eq(edit_address_path(@address_1.id))
    expect(page).to have_content("City can't be blank, State can't be blank, Zip can't be blank, and Nickname can't be blank")
  end

  it 'A flash message will display an error if the address is associated with a pending order' do
    create(:order, user: @user, address: @address_1, status: 'pending')

    visit '/profile'

    within "#address-#{@address_1.id}" do
      click_on 'Edit Address'
    end

    expect(current_path).to eq("/addresses/#{@address_1.id}/edit")
    expect(page).to have_content("This address is currently associated with a pending order. Making changes to this address will change any orders associated with the address.")
  end
end
