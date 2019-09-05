class OrdersController <ApplicationController

  def new

  end

  def show
    user = User.find(session[:user_id])
    if params[:order_id]
      @order = Order.find(params[:order_id])
    else
      @orders =  Order.where(user_id: params[:id])
    end
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
