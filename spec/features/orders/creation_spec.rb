RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @tire = create(:item)
      @paper = create(:item)
      @pencil = create(:item)
      @user = create(:user)

      visit '/login'

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password

      within '#login-form' do
        click_on 'Log In'
      end

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
      expect(page).to have_button('Create Order')

      click_button 'Create Order'

      new_order = Order.last

      expect(current_path).to eq("/orders/#{new_order.id}")

      within '.shipping-address' do
        expect(page).to have_content(@user.name)
        expect(page).to have_content(@user.address)
        expect(page).to have_content(@user.city)
        expect(page).to have_content(@user.state)
        expect(page).to have_content(@user.zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$#{@paper.price * 2}")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$#{@tire.price}")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$#{@pencil.price}")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $120.00")
      end

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at.strftime('%D'))
      end
    end
  end
end
