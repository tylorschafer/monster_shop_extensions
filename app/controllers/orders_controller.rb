class OrdersController <ApplicationController

  def index
    @user = User.find(session[:user_id])
  end

  def new
    @user = User.find(session[:user_id])
    session[:creating_order] = 'true'
    if session[:address_id]
      @address = Address.find(session[:address_id])
      @selected_address = true
    elsif @user.addresses == []
      @address = Address.new
    else
      @has_address = true
      @addresses = @user.addresses
    end
  end

  def cancel_item_orders(order)
    order.item_orders.each do |item_order|
      item_order.status = "unfulfilled"
      item = Item.find(item_order.item_id)
      item.restock(item_order.quantity)
      item_order.save
    end
  end

  def cancel
    order = Order.find(params[:id])
    cancel_item_orders(order)
    order.status = "cancelled"
    order.save
    if current_admin?
      flash[:success] = "You destroyed the users order dawg"
      redirect_to "/admin"
    else
      flash[:success] = "Your order has been cancelled dawg"
      redirect_to "/profile"
    end
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def create_item_orders(order)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
    end
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(user_info(user))
    create_item_orders(order)
    delete_session
    redirect_to "/profile/orders"
    flash[:success] = "Thank You For Your Order!"
  end

  def ship
    order = Order.find(params[:order_id])
    order.update(status: 'shipped')
    order.save
    flash[:success] = "Order No. #{order.id} has been shipped, yo!"
    redirect_to "/admin"
  end

  def remove_address
    session.delete(:address_id)
    redirect_to '/orders/new'
  end

  def select_address
    session[:address_id] = params[:address_id]
    redirect_to '/orders/new'
  end

  private

  def user_info(user)
    info = Hash.new
    selected_address = Address.find(session[:address_id])
    info[:name] = user.name
    info[:address] = selected_address.address
    info[:city] = selected_address.city
    info[:state] = selected_address.state
    info[:zip] = selected_address.zip
    info
  end

  def delete_session
    session.delete(:cart)
    session.delete(:address_id)
    session.delete(:creating_order)
  end
end
