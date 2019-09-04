require 'rails_helper'

describe 'User clicks link to sign up' do
  before :each do
    @name = 'Bobb'
    @address = '234 A st'
    @city = 'Wonderland'
    @state = 'CA'
    @zip = 90345
    @email = 'bobb@gmail.com'
    @password = 'supersafe'
  end
  it 'They are taken to a form to register' do
    visit '/'

    within '.login-options' do
      click_link 'Sign Up'
    end

    expect(current_path).to eq('/register')


    fill_in :name, with: @name
    fill_in :address, with: @address
    fill_in :city, with: @city
    fill_in :state, with: @state
    fill_in :zip, with: @zip
    fill_in :email, with: @email
    fill_in :password, with: @password

    click_on 'Submit'

    expect(current_path).to eq('/profile')
  end

  it 'The field cant have blanks' do
    visit '/register'

    click_on 'Submit'

    expect(current_path).to eq('/register')
    expect(page).to have_content("Name can't blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank and Password can't be blank.")
  end

  it 'Cant reuse email addresses' do
    user = User.create(name: @name, address: @address, city: @city, state: @state, zip: @zip, email: @email, password: @password)

    fill_in :name, with: @name
    fill_in :address, with: @address
    fill_in :city, with: @city
    fill_in :state, with: @state
    fill_in :zip, with: @zip
    fill_in :email, with: @email
    fill_in :password, with: @password

    click_on 'Submit'

    expect(current_path).to eq('/register')
    expect(page).to have_content('Username has already been taken')
  end
end
