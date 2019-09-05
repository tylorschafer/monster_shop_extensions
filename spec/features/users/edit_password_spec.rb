require 'rails_helper'

describe 'User clicks Change Password in their profile' do
  it 'Makes them enter their old password and a new password with confirmation' do
    user = create(:user)

    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    click_link('Change Password')

    fill_in 'Old password', with: user.password
    fill_in 'New password', with: 'newpass'
    fill_in 'New password confirmation', with: 'newpass'

    click_on 'Update Password'

    expect(current_path).to eq('/user/profile')
    expect(page).to have_content('You got a fresh new password, dawg!')
  end

  it 'Needs to have the correct old password' do
    user = create(:user)

    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    click_link('Change Password')

    fill_in 'Old password', with: 'badpass'
    fill_in 'New password', with: 'newpass'
    fill_in 'New password confirmation', with: 'newpass'

    click_on 'Update Password'

    expect(current_path).to eq('/user/profile/edit_password')
    expect(page).to have_content("Your old password didn't match the one on record")
  end

  it 'Needs to have matching new passwords' do
    user = create(:user)

    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    click_link('Change Password')

    fill_in 'Old password', with: user.password
    fill_in 'New password', with: 'newpass'
    fill_in 'New password confirmation', with: 'badpass'

    click_on 'Update Password'

    expect(current_path).to eq('/user/profile/edit_password')
    expect(page).to have_content("Your new password didn't match the confirmation")
  end
end
