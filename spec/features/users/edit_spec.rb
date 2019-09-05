require 'rails_helper'

describe 'User clicks Edit Profile link in their profile' do
  it 'Takes them to a prepopulated form to edit their info' do
    user = create(:user)

    visit '/login'

    within "#login-form" do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log In'
    end

    click_link 'Edit Profile'

    expect(current_path).to eq('/profile/edit')

    click_on 'Update Profile'

    expect(current_path).to eq('/profile')

    click_link 'Edit Profile'

    fill_in 'Name', with: 'Maria'
    fill_in 'Address', with: '123 A st.'
    fill_in 'City', with: 'San Pedro'
    fill_in 'State', with: 'CA'
    fill_in 'Zip', with: '92345'
    fill_in 'Email', with: 'maria@email.com'

    click_on 'Update Profile'

    expect(page).to have_content('Profile updated')

    within '.user-profile' do
      expect(page).to have_content("Maria's Profile")
      expect(page).to have_content("123 A st.")
      expect(page).to have_content("San Pedro, CA 92345")
      expect(page).to have_content("Email: maria@email.com")
    end
  end
end
# As a registered user
# When I visit my profile page
# I see a link to edit my profile data
# When I click on the link to edit my profile data
# I see a form like the registration page
# The form is prepopulated with all my current information except my password
# When I change any or all of that information
# And I submit the form
# Then I am returned to my profile page
# And I see a flash message telling me that my data is updated
# And I see my updated information
