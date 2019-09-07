class Merchant::ItemsController < Merchant::BaseController

    def fulfill_item
        order = Order.find(params[:order_id])
        item_order = ItemOrder.find_by(order_id: order.id, item_id: params[:item_id])
        item = Item.find(item_order.item_id)
        item.fulfill(item_order.quantity)
        item_order.fulfill
        order.update_status
        flash[:success] = "#{item.name} has been fulfilled"
        redirect_to "/merchant/orders/#{item_order.order_id}"
    end
end