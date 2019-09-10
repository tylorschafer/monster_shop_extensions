class Merchant::DashboardController < Merchant::BaseController

  def index
    @user = User.find(session[:user_id])
    if @user.role == 'admin'
      @merchant = Merchant.find(params[:id])
    else
      @merchant = @user.merchant
    end
    @pending_orders = @merchant.pending_orders
    session[:merchant_id] = @merchant.id
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
