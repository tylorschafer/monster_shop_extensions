class MerchantsController <ApplicationController
  before_action :valid_merchant, only: [:show]

  def index
    if current_admin? == false
      @merchants = Merchant.all.where(status: 0)
    else
      @merchants = Merchant.all
    end
  end

  def my_coupons
    coupons
  end

  def show
    @merchant = Merchant.find(params[:id])
    if current_merchant?
      @works_here = @merchant.works_here?(current_user.merchant.id)
    end
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to "/merchants"
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
    user = User.find(session[:user_id])
    render file: "/public/404" unless current_merchant_admin? && @merchant.works_here?(user.merchant.id)
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to "/merchants/#{@merchant.id}"
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Item.delete(Item.where(merchant_id: params[:id]))
    Merchant.destroy(params[:id])
    redirect_to '/merchants'
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end

  def valid_merchant
    render file: "/public/404" unless Merchant.find(params[:id]).status == 'enabled'
  end
end
