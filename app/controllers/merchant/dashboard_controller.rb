class Merchant::DashboardController < Merchant::BaseController

  def index
    @user = User.find(session[:user_id])
    @merchant = @user.merchant
  end

end
