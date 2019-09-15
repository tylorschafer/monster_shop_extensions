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
    address = Address.find(params[:id])
    address.update(address_params)
    if address.save
      redirect_to '/profile'
    else
      flash[:error] = address.errors.full_messages.to_sentence
      redirect_to edit_address_path(address)
    end
  end

  def destroy
    address = Address.find(params[:id])
    session.delete[:address_id] if session[:address_id] == address.id
    address.delete
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
