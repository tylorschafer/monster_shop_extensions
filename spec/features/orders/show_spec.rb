require 'rails_helper'

describe 'user order show page' do
  before :each do
    @tire = create(:item, inventory: 10, price: 35)
    @paper = create(:item, inventory: 10, price: 40)
    @admin = create(:user, role: 4)
    @user_1 = create(:user)
    @address_1 = create(:address, user: @user_1)
    @address_3 = create(:address, user: @user_1)
    @order = create(:order, user: @user_1, address: @address_1)
    @user_2 = create(:user)
    @address_2 = create(:address, user: @user_2)
    @order_2 = create(:order, status: 2, user: @user_2, address: @address_2)
    @item_order_1 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @item_order_2 = @order.item_orders.create!(item: @paper, price: @paper.price, quantity: 4)

    visit '/login'

    fill_in 'Email', with: @user_1.email
    fill_in 'Password', with: @user_1.password

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
    expect(page).to have_content(@address_1.street)
    expect(page).to have_content(@address_1.city)
    expect(page).to have_content(@address_1.state)
    expect(page).to have_content(@address_1.zip)

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
    expect(page).to have_content("Date Placed: #{@order.created_at.strftime('%D')}")
    expect(page).to have_content("Last Updated: #{@order.updated_at.strftime('%D')}")
  end

  it "I can cancel an order if the order is still pending" do

    visit "/profile/orders/#{@order.id}"

    expect(page).to have_button("Cancel Order")

    click_button "Cancel Order"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Your order has been cancelled")

    visit "/profile/orders/#{@order.id}"

    within ".shipping-address" do
      expect(page).to have_content("cancelled")
    end

    within "#item-#{@item_order_1.item_id}" do
      expect(page).to have_content("unfulfilled")
    end

    within "#item-#{@item_order_2.item_id}" do
      expect(page).to have_content("unfulfilled")
    end
  end

  it "An order that is beyond the pending stage cannot be cancelled" do
    visit "/orders/#{@order_2.id}"

    expect(page).to_not have_button("Cancel Order")
  end

  it "admin can cancel an order" do
    admin = create(:user, role: 4)
    click_on 'Log Out'

    visit '/login'

    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password

    within '#login-form' do
      click_on 'Log In'
    end

    visit "admin/users/#{@order.user_id}/orders/#{@order.id}"

    click_on 'Cancel Order'

    expect(current_path).to eq('/admin')
    expect(page).to have_content('You destroyed the users order dawg')
  end

  it 'pending_orders can have their addresses changed' do
    visit "/profile/orders/#{@order.id}"

    click_link 'Select a Different Shipping Address'

    expect(current_path).to eq("/profile/orders/#{@order.id}/addresses/select")

    within "#address-#{@address_3.id}" do
      click_link 'Select'
    end

    expect(current_path).to eq('/profile/orders')
    expect(page).to have_content("You have changed the address for order ##{@order.id}")

    visit "/profile/orders/#{@order.id}"

    expect(page).to have_content(@address_3.street)
    expect(page).to have_content(@address_3.city)
    expect(page).to have_content(@address_3.state)
    expect(page).to have_content(@address_3.zip)
  end
end
