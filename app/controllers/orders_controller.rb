class OrdersController <ApplicationController

  def index
    @user = User.find(session[:user_id])
  end

  def new
  end

  def update
    order = Order.find(params[:id])
    order.item_orders.each do |item_order|
      item_order.status = "unfulfilled"
    end
    order.status = "cancelled"
    order.save
    flash[:success] = "Your order has been cancelled"
    redirect_to "/profile"
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
