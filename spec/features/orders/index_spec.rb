require 'rails_helper'

describe 'User order index page' do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @meg.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @meg.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @user = create(:user)
    @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @order_2 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @orders = [@order_1,@order_2]
    @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @item_order_2 = @order_2.item_orders.create!(item: @paper, price: @paper.price, quantity: 4)
    @item_order_3 = @order_2.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 6)

    visit '/login'

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    within '#login-form' do
      click_on 'Log In'
    end
  end
  it "shows all user orders" do
    visit '/profile/orders'

    @orders.each do |order|
      within "#order-#{order.id}" do
        expect(page).to have_link(order.id)
        expect(page).to have_content("Date Placed: #{order.created_at.strftime('%F %T')}")
        expect(page).to have_content("Last Updated: #{order.updated_at.strftime('%F %T')}")
        expect(page).to have_content("Status: #{order.status}")
        expect(page).to have_content("Items Count: #{order.items_count}")
        expect(page).to have_content("Grand Total: #{order.grandtotal}")
      end
    end
  end
end
