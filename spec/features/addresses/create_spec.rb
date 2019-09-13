require 'rails_helper'

describe 'new user creation' do
  before :each do
    @name = 'Bobb'
    @address = '234 A st'
    @city = 'Wonderland'
    @state = 'CA'
    @zip = 90345
    @email = 'bobb@gmail.com'
    @password = 'supersafe'
  end
  describe 'the address the user enters into the new user form' do
    it 'is saved into the addresses database and given a default nickname of Home' do
      visit '/'

      within '.login-options' do
        click_link 'Sign Up'
      end

      fill_in 'Name', with: @name
      fill_in 'Address', with: @address
      fill_in 'City', with: @city
      fill_in 'State', with: @state
      fill_in 'Zip', with: @zip
      fill_in 'Email', with: @email
      fill_in 'Password', with: @password
      fill_in 'Password confirmation', with: @password

      click_on 'Submit'

      new_address = Address.last
      new_user = User.last

      expect(new_address.address).to eq(@address)
      expect(new_address.city).to eq(@city)
      expect(new_address.state).to eq(@state)
      expect(new_address.zip).to eq(@zip)
      expect(new_address.nickname).to eq('Home')
      expect(new_address.user_id).to eq(new_user.id)
    end
  end
end
