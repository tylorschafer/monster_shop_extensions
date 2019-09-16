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
  it 'Addresses can be deleted' do
    visit '/profile'

    within "#address-#{@address_1.id}" do
      expect(page).to have_link('Delete Address')
      click_on 'Delete Address'
    end

    expect(current_path).to eq('/profile')

    expect(page).to_not have_content(@address_1.nickname)
    expect(page).to_not have_content(@address_1.street)
    expect(page).to_not have_content(@address_1.city)
    expect(page).to_not have_content(@address_1.state)
    expect(page).to_not have_content(@address_1.zip)

    within "#address-#{@address_2.id}" do
      expect(page).to have_content(@address_2.nickname)
      expect(page).to have_content(@address_2.street)
      expect(page).to have_content(@address_2.city)
      expect(page).to have_content(@address_2.state)
      expect(page).to have_content(@address_2.zip)
    end
  end

  it 'An address will not have a delete or edit link if it is associated with a shipped order' do
    create(:order, address: @address_1, status: 'shipped')

    visit '/profile'

    within "#address-#{@address_1.id}" do
      expect(page).to_not have_link('Delete Address')
      expect(page).to_not have_link('Update Address')
    end
  end

  it 'An address will display a flash message if it is associated with a pending order' do
    create(:order, address: @address_1, status: 'pending')

    visit '/profile'

    within "#address-#{@address_1.id}" do
      click_link 'Delete Address'
    end

    expect(current_path).to eq('/profile')
    expect(page).to have_content("This address is associated with a pending order, you must select a different address for your orders before deleting this")
  end
end
