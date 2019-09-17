class Merchant::CouponsController < Merchant::BaseController

  def index
    user = User.find(session[:user_id])
    @merchant = user.merchant
    @coupons = @merchant.coupons
  end

  def new
    @coupon = Coupon.new
  end

  def create
    user = User.find(session[:user_id])
    merchant = user.merchant
    @coupon = merchant.coupons.create(coupon_params)
    if @coupon.save
      flash[:success] = "You Created a New Coupon"
      redirect_to merchant_coupons_path
    else
      flash[:errors] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    @coupon.update(coupon_params)
    if @coupon.save
      flash[:success] = "You Create a New Coupon"
      redirect_to merchant_coupons_path
    else
      flash[:errors] = @coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    coupon = Coupon.find(params[:id])
    coupon.destroy
    redirect_to merchant_coupons_path
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :type, :rate, :coupon_type)
  end

end
