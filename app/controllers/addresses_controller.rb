class AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def create
    user = User.find(session[:user_id])
    @address = user.addresses.create(address_params)
    if @address.save
      find_redirect
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render '/orders/new'
    end
  end

  private

  def address_params
    params.require(:address).permit(:address, :city, :state, :zip)
  end

  def find_redirect
    if session[:creating_order] == 'true'
      redirect_to '/orders/new'
    else
      redirect_to '/profile'
    end
  end
end
