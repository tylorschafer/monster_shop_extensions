# When I fill out all information on the new order page
# And click on 'Create Order'
# An order is created and saved in the database
# And I am redirected to that order's show page with the following information:
#
# - Details of the order:

# - the date when the order was created
RSpec.describe("Order Creation") do
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

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can create a new order' do
      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/orders/#{new_order.id}")

      within '.shipping-address' do
        expect(page).to have_content(name)
        expect(page).to have_content("#{address}, #{city}, #{state} #{zip}")
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_content(@paper.name)
        expect(page).to have_content("Sold by: #{@paper.merchant.name}")
        expect(page).to have_content("Price: $#{@paper.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: $40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Sold by: #{@tire.merchant.name}")
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $100")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_content(@pencil.name)
        expect(page).to have_content("Sold by: #{@pencil.merchant.name}")
        expect(page).to have_content("Price: $#{@pencil.price}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $2")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $142")
      end

      within "#datecreated" do
        expect(page).to have_content(Date.today)
      end
    end


  end
end
