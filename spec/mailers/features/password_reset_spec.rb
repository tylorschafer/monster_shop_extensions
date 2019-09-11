require 'rails_helper'

RSpec.describe "Reset Password via Email" do
    before :each do
        @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
        @evette = @dog_shop.users.create(name: 'Evette', address: '12345 C St', city: 'Los Angeles', state: 'CA', zip: 90210, email: 'evette@email.com', password: 'sue', password_confirmation: 'sue', role: 3)
    end
    describe "create email with password reset info" do
        it "takes user email to reset pw" do
            visit '/login'
            click_link "Forgot yo password? alzheimer's? NO WORRIES!"

            fill_in "Email", with: @evette.email
            click_button "Reset Password"
            expect(current_path).to eq("/login")
            expect(page).to have_content("We sent you an email with instructions!")
        end
    end
end