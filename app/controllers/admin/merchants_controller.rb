class Admin::MerchantsController < Admin::BaseController

  def update
    merchant = Merchant.find(params[:id])
    if merchant.status == 'disabled'
      merchant.status = 0
    else
      merchant.status = 1
    end
    merchant.save
    redirect_to '/merchants'
  end
end
