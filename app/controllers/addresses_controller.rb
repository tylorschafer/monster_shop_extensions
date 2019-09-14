class AddressesController < ApplicationController

  def create
    user = User.find(session[:user_id])
    @address = user.addresses.create(address_params)
    if @address.save
      redirect_to '/orders/new'
    else
      flash[:error] = @address.errors.full_messages
      render '/orders/new'
    end
  end

  def select
    session[:address_id] = params[:address_id]
    redirect_to '/orders/new'
  end

  private

  def address_params
    params.require(:address).permit(:address, :city, :state, :zip)
  end
end
