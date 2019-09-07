class Merchant::ItemsController < Merchant::BaseController

    def fulfill_item
        item_order = ItemOrder.find_by(order_id: params[:order_id], item_id: params[:item_id])
        item = Item.find(item_order.item_id)
        item.fulfill(item_order.quantity)
        item_order.fulfill
        flash[:success] = "#{item.name} has been fulfilled"
        redirect_to "/merchant/orders/#{item_order.order_id}"
    end
end