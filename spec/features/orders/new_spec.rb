# As a visitor
# When I check out from my cart
# On the new order page I see the details of my cart:
# - the name of the item
# - the merchant I'm buying this item from
# - the price of the item
# - my desired quantity of the item
# - a subtotal (price multiplied by quantity)
# - a grand total of what everything in my cart will cost
# I also see a form to where I must enter my shipping information for the order:
# - name
# - address
# - city
# - state
# - zip
# I also see a button to 'Create Order'

RSpec.describe("New Order Page") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end
    it "I see all the information about my current cart" do
      visit "/cart"

      click_on "Checkout"

      within "#order-item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Sold by: #{@tire.merchant.name}")
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $100")
      end

      within "#order-item-#{@paper.id}" do
        expect(page).to have_content(@paper.name)
        expect(page).to have_content("Sold by: #{@paper.merchant.name}")
        expect(page).to have_content("Price: $#{@paper.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: $40")
      end

      within "#order-item-#{@pencil.id}" do
        expect(page).to have_content(@pencil.name)
        expect(page).to have_content("Sold by: #{@pencil.merchant.name}")
        expect(page).to have_content("Price: $#{@pencil.price}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $2")
      end

      expect(page).to have_content("Total: $142")
    end

    it "I see a form where I can enter my shipping info" do
      visit "/cart"
      click_on "Checkout"

      expect(page).to have_field(:name)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)
      expect(page).to have_button("Create Order")
    end
  end
end
