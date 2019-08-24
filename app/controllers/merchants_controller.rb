class MerchantsController <ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    Merchant.create(merchant_params)
    redirect_to "/merchants"
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to "/merchants/#{@merchant.id}"
    else
      flash[:error] = "Please fill in the following field(s): " + find_empty_params
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

  def find_empty_params
    empty_params = []
    empty_params << "Name " if merchant_params[:name] == ""
    empty_params << "Address " if merchant_params[:address] == ""
    empty_params << "City " if merchant_params[:city] == ""
    empty_params << "State " if merchant_params[:state] == ""
    empty_params << "Zip " if merchant_params[:zip] == ""
    empty_params.join(", ")
  end
end
