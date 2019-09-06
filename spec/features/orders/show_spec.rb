require 'rails_helper'

describe 'user order show page' do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @meg.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @order = create(:order)
    @item_order_1 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @item_order_2 = @order.item_orders.create!(item: @paper, price: @paper.price, quantity: 4)

    visit '/login'

    fill_in 'Email', with: @order.user.email
    fill_in 'Password', with: @order.user.password

    within '#login-form' do
      click_on 'Log In'
    end
  end
  it "shows info on a single order" do
    visit '/profile/orders'

    click_link @order.id

    expect(current_path).to eq("/profile/orders/#{@order.id}")

    expect(page).to have_content(@order.id)
    expect(page).to have_content(@order.status)
    expect(page).to have_content(@order.name)
    expect(page).to have_content(@order.address)
    expect(page).to have_content(@order.city)
    expect(page).to have_content(@order.state)
    expect(page).to have_content(@order.zip)

    within "#item-#{@item_order_1.item_id}" do
      expect(page).to have_link(@item_order_1.item.name)
      expect(page).to have_link(@item_order_1.item.merchant.name)
      expect(page).to have_content("$100.00")
      expect(page).to have_content(@item_order_1.quantity)
      expect(page).to have_content("$200.00")
    end

    within "#item-#{@item_order_2.item_id}" do
      expect(page).to have_link(@item_order_2.item.name)
      expect(page).to have_link(@item_order_2.item.merchant.name)
      expect(page).to have_content("$20.00")
      expect(page).to have_content(@item_order_2.quantity)
      expect(page).to have_content("$80.00")
    end

    expect(page).to have_content("Total: $280.00")
    expect(page).to have_content("Date Placed: #{@order.created_at.strftime('%F %T')}")
    expect(page).to have_content("Last Updated: #{@order.updated_at.strftime('%F %T')}")
  end
end
