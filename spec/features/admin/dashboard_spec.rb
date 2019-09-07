require 'rails_helper'

describe 'admin dashboard' do
  before :each do
    @admin = create(:user, role: 4)
    @order_1 = create(:order, status: 0)
    @order_2 = create(:order, status: 1)
    @order_3 = create(:order, status: 2)
    @order_4 = create(:order, status: 3)

    visit login_path

    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password

    within '#login-form' do
      click_on 'Log In'
    end
  end
  it "admin can see all orders in the system" do
    visit "/admin"

    within "#pending-order-#{@order_1.id}" do
      expect(page).to have_content("Order Placed By: #{@order_1.user.name}")
      expect(page).to have_link(@order_1.id)
      expect(page).to have_content("Ordered on: #{@order_1.created_at.strftime('%F %T')}")
    end

    within "#packaged-order-#{@order_2.id}" do
      expect(page).to have_content("Order Placed By: #{@order_2.user.name}")
      expect(page).to have_link(@order_2.id)
      expect(page).to have_content("Ordered on: #{@order_2.created_at.strftime('%F %T')}")
    end

    within "#shipped-order-#{@order_3.id}" do
      expect(page).to have_content("Order Placed By: #{@order_3.user.name}")
      expect(page).to have_link(@order_3.id)
      expect(page).to have_content("Ordered on: #{@order_3.created_at.strftime('%F %T')}")
    end

    within "#cancelled-order-#{@order_4.id}" do
      expect(page).to have_content("Order Placed By: #{@order_4.user.name}")
      expect(page).to have_link(@order_4.id)
      expect(page).to have_content("Ordered on: #{@order_4.created_at.strftime('%F %T')}")
    end
  end
end
