class AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def create
    user = User.find(session[:user_id])
    @address = user.addresses.create(address_params)
    unless @address.save
      flash[:error] = @address.errors.full_messages.to_sentence
    end
    find_redirect
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    Address.find(params[:id]).update(address_params)
    redirect_to '/profile'
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end

  def find_redirect
    if session[:creating_order] == 'true'
      redirect_to '/orders/new'
    else
      redirect_to '/profile'
    end
  end
end
