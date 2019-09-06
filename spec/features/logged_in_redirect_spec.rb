require 'rails_helper'

describe 'User logs in and tries to visit /login' do
  it 'Redirects a user to their profile' do
    user = create(:user)

    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    visit '/login'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Silly pup, you are already logged in!')
  end

  it 'Redirects a merchant to their merchant dashboard' do

  end

  it 'Redirects an admin to their admin dashboard' do

  end
end
