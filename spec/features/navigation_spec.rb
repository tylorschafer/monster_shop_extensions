
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        within '#home-indicator' do
          click_link
        end
      end

      expect(current_path).to eq('/')

      within 'nav' do
        within '.login-options' do
          click_link 'Sign Up'
        end

        expect(current_path).to eq('/user/register')
      end

      within 'nav' do
        within '.login-options' do
          click_link 'Log In'
        end

        expect(current_path).to eq('/login')
      end
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("0 items")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("0 items")
      end
    end
  end
end
