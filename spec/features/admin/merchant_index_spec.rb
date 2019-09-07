require 'rails_helper'

describe 'merchant index as an admin' do
  before :each do
    @merchant_1 = create(:merchant, status: enabled)
    @merchant_2 = create(:merchant, status: enabled)
    @merchant_3 = create(:merchant, status: disabled)
    @merchants = [@merchant_1,@merchant_2,@merchant_3]
    @user = create(:user)
    @admin = create(:user, role: 4)

    visit login_path

    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password

    within '#login-form' do
      click_on 'Log In'
    end
  end

  it "merchant info is shown and namex are links to namespaced admin merchant show page" do

    @merchants.each do |merchant|
      within "#merchant-#{merchant.id}" do
        visit '/merchants'

        expect(page).to have_link(merchant.name)
        expect(page).to have_link(merchant.name)
        expect(page).to have_link(merchant.name)
        expect(page).to have_content(merchant.status)

        click_link(merchant.name)

        expect(current_path).to eq("/admin/merchants/#{@merchant_3.id}")
      end
    end
  end

  it "merchants can be enabled and disabled " do
    visit '/merchants'

    within "#merchant-#{@merchant_1.id}" do
      expect(page).to have_button('Disable')

      click_button 'Disable'

      expect(current_path).to eq('/merchants')

      expect(page).to_not have_button('Disable')
    end
  end

  it "Other users do not have access to this functionality" do
    click_on 'Log Out'

    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    within '#login-form' do
      click_on 'Log In'
    end

    visit '/merchants'

    click_link(@merchant_1.name)

    expect(current_path).to eq("/merchants/#{@merchant_1.id}")

    visit '/merchants'

    expect(page).to_not have_button('Disable')
  end
end
