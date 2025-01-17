class OrdersController <ApplicationController

  def index
    @user = User.find(session[:user_id])
  end

  def new
    @user = User.find(session[:user_id])
    session[:creating_order] = 'true'
    if session[:address_id]
      select_order_address
    elsif @user.addresses == []
      @address = Address.new
    else
      user_addresses
    end
  end

  def user_addresses
    @has_address = true
    @addresses = @user.addresses
  end

  def select_order_address
    @address = Address.find(session[:address_id])
    @selected_address = true
    if session[:has_coupon]
      @coupon = Coupon.find_by(name: session[:has_coupon])
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
    cancelled_address(order)
    order.save
    cancel_finalize
  end

  def cancelled_address(order)
    user = order.user
    admin = User.find_by(role: 'admin')
    default_address ||= Address.create!(nickname: 'Admin', street: 'Cancelled', city: 'Cancelled', state: 'Cancelled', zip: 99999, user: admin)
    order.address = default_address
  end

  def cancel_finalize
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

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(user_info(user))
    load_coupon(order)
    create_item_orders(order)
    delete_session
    redirect_to "/profile/orders"
    flash[:success] = "Thank You For Your Order!"
  end

  def load_coupon(order)
    coupon = Coupon.find_by(name: session[:has_coupon])
    order.coupon = coupon
    order.save
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


  def select_address
    if session[:pending_address_select] == 'true'
      update_address
    else
      session[:address_id] = params[:address_id]
      redirect_to '/orders/new'
    end
  end

  def update_address
    order = Order.find(session[:order_id])
    order.address = Address.find(params[:address_id])
    order.save
    redirect_to "/profile/orders"
    session.delete(:order_id)
    session.delete(:pending_address_select)
    flash[:success] = "You have changed the address for order ##{order.id}"
  end

  def add_coupon
    coupon = Coupon.find_by(name: params[:coupon_code])
    if coupon.nil?
      flash[:error] = "Sorry that is not a valid coupon"
      redirect_to "/orders/new"
    else
      session[:has_coupon] = coupon.name
      redirect_to "/orders/new"
    end
  end

  def ship
    order = Order.find(params[:order_id])
    order.update(status: 'shipped')
    order.save
    flash[:success] = "Order No. #{order.id} has been shipped, yo!"
    redirect_to "/admin"
  end

  private

  def user_info(user)
    info = Hash.new
    selected_address = Address.find(session[:address_id])
    info[:name] = user.name
    info[:address_id] = selected_address.id
    info
  end

  def delete_session
    session.delete(:cart)
    session.delete(:address_id)
    session.delete(:creating_order)
    session.delete(:has_coupon)
  end
end
