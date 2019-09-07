require 'rails_helper'

describe 'User logged in as admin visits /cart'do
  it 'Returns 404' do
    admin = create(:user, role: 4)

    visit login_path

    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password

    within '#login-form' do
      click_on 'Log In'
    end

    visit cart_path
    
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
