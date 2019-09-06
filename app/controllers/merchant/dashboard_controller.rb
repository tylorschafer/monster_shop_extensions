class Merchant::DashboardController < Merchant::BaseController

  def index
    @user = User.find(session[:user_id])
    @merchants = @user.merchants
  end

end
