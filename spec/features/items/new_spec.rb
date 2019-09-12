require 'rails_helper'

RSpec.describe "Create Merchant Items" do
  describe "When I visit the merchant items index page" do
    before(:each) do
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = create(:user, role: 3, merchant_id: @brian.id)
      visit '/login'

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password

      within '#login-form' do
        click_on 'Log In'
      end
    end

    it 'I see a link to add a new item for that merchant' do

      visit "/merchant/items"

      expect(page).to have_link "Add a New Item"
    end

    it 'I can add a new item by filling out a form' do
      visit "/merchant/items"

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      click_on "Add a New Item"

      expect(page).to have_link(@brian.name)
      expect(current_path).to eq("/merchant/items/new")
      fill_in 'Name', with: name
      fill_in 'Price', with: price
      fill_in 'Description', with: description
      fill_in 'Image', with: image_url
      fill_in 'Inventory', with: inventory

      click_on "Submit"

      new_item = Item.last

      expect(current_path).to eq("/merchant/items")
      expect(new_item.name).to eq(name)
      expect(new_item.price).to eq(price)
      expect(new_item.description).to eq(description)
      expect(new_item.image).to eq(image_url)
      expect(new_item.inventory).to eq(inventory)
      expect(Item.last.active?).to be(true)
      expect("#item-#{Item.last.id}").to be_present
      expect(page).to have_content(name)
      expect(page).to have_content("$#{new_item.price}")
      expect(page).to have_css("img[src*='#{new_item.image}']")
      expect(page).to have_content("active")
      expect(page).to_not have_content(new_item.description)
      expect(page).to have_content("#{new_item.inventory}")
    end

    it 'I get an alert if I dont fully fill out the form' do
      visit "/merchant/items"

      name = ""
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = ""

      click_on "Add a New Item"

      fill_in 'Name', with: name
      fill_in 'Price', with: price
      fill_in 'Description', with: description
      fill_in 'Image', with: image_url
      fill_in 'Inventory', with: inventory

      click_button "Submit"

      expect(page).to have_content("Name can't be blank and Inventory is not a number")
      expect(page).to have_button("Submit")
    end

    it 'default image populates for items with no image url' do
      visit "/merchant/items"

      name = "A Thing"
      price = 18
      description = "No more chaffin'!"
      image_url = ""
      inventory = 12

      click_on "Add a New Item"

      fill_in 'Name', with: name
      fill_in 'Price', with: price
      fill_in 'Description', with: description
      fill_in 'Image', with: image_url
      fill_in 'Inventory', with: inventory

      click_button "Submit"

      item = Item.find_by(description: description, inventory: inventory, price: price)

      expect(page).to have_content("#{name} has been added")
      expect(item.image).to eq("https://i.ibb.co/0jybzgd/default-thumbnail.jpg")
    end
  end
end
