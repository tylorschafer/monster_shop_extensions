class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id)
    flash[:notice] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end
end
