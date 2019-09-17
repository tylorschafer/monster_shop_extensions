class Merchant::CouponsController < Merchant::BaseController

  def index
    user = User.find(session[:user_id])
    merchant = user.merchant
    @coupons = merchant.my_coupons
  end
end
