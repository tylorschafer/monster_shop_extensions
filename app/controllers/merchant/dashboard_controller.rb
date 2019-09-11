class Merchant::DashboardController < Merchant::BaseController

  def index
    if current_admin?
      render file: "/public/404"
    else
      @user = User.find(session[:user_id])
      @merchant = @user.merchant
      @pending_orders = @merchant.pending_orders
      session[:merchant_id] = @merchant.id
    end
  end

  def items
    @merchant = Merchant.find(session[:merchant_id])
    @items = @merchant.items
  end

  def order_show
    @order = Order.find(params[:id])
    user = User.find(session[:user_id])
    @merchant_items = @order.merchant_items(user.merchant)
  end

end
