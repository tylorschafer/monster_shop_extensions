require 'rails_helper'

describe 'user order show page' do
  before :each do
    @tire = create(:item, inventory: 10)
    @paper = create(:item, inventory: 10)
    @order = create(:order)
    @order_2 = create(:order, status: 2)
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
      expect(page).to have_content("$35.00")
      expect(page).to have_content(@item_order_1.quantity)
      expect(page).to have_content("$70.00")
    end

    within "#item-#{@item_order_2.item_id}" do
      expect(page).to have_link(@item_order_2.item.name)
      expect(page).to have_link(@item_order_2.item.merchant.name)
      expect(page).to have_content("$40.00")
      expect(page).to have_content(@item_order_2.quantity)
      expect(page).to have_content("$160.00")
    end

    expect(page).to have_content("Total: $230.00")
    expect(page).to have_content("Date Placed: #{@order.created_at.strftime('%F %T')}")
    expect(page).to have_content("Last Updated: #{@order.updated_at.strftime('%F %T')}")
  end

  it "I can cancel an order if the order is still pending" do

    visit "/profile/orders/#{@order.id}"

    expect(page).to have_button("Cancel Order")

    expect(current_path).to eq("/profile/orders/")

    within "#order-#{@order.id}" do
      expect(page).to have_content("Status: Cancelled")
    end

    expect(page).to have_content("Your order has been cancelled")
  end

  it "An order that is beyond the pending stage cannot be cancelled" do
    visit "/orders/#{@order_2.id}"

    expect(page).to_not have_button("Cancel Order")
  end
end
