class Merchant::DashboardController < Merchant::BaseController

  def index
    binding.pry
    @user = User.find(session[:user_id])
    @merchant = @user.merchant
    @pending_orders = @merchant.pending_orders
  end

end
