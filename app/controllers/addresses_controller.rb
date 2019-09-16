class AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def create
    user = User.find(session[:user_id])
    @address = user.addresses.create(address_params)
    if @address.save
      flash[:success] = "You have created a new address"
    else
      flash[:error] = @address.errors.full_messages.to_sentence
    end
    find_redirect
  end

  def edit
    @address = Address.find(params[:id])
    if @address.has_pending_orders?
      flash[:error] = "This address is currently associated with a pending order. Making changes to this address will change any orders associated with the address."
    end
  end

  def update
    address = Address.find(params[:id])
    address.update(address_params)
    if address.save
      flash[:sucess] = 'You have updated your address'
      redirect_to '/profile'
    else
      flash[:error] = address.errors.full_messages.to_sentence
      redirect_to edit_address_path(address)
    end
  end

  def destroy
    address = Address.find(params[:id])
    if address.has_pending_orders?
      flash[:error] = "This address is associated with a pending order, you must select a different address for your orders before deleting this"
      redirect_to '/profile'
    else
      session.delete(:address_id)
      address.delete
      flash[:success] = 'Your address has been deleted'
      redirect_to '/profile'
    end
  end

  def select
    user = User.find(session[:user_id])
    session[:order_id] = params[:order_id]
    @addresses = user.addresses
    session[:pending_address_select] = 'true'
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :street, :city, :state, :zip)
  end

  def find_redirect
    if session[:creating_order] == 'true'
      redirect_to '/orders/new'
    else
      redirect_to '/profile'
    end
  end
end
