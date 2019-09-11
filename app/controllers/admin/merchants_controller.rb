class Admin::MerchantsController < Admin::BaseController

  def update
    merchant = Merchant.find(params[:id])
    if merchant.status == 'disabled'
      merchant.enable
      flash[:success] = "#{merchant.name} has been enabled"
    else
      merchant.disable
      flash[:success] = "#{merchant.name} has been disabled"
    end
    redirect_to '/merchants'
  end

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
end
