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

    def update
        item = Item.find(params[:id])
        if item.active? == true
            item.update(active?: false)
            item.save
        elsif item.active? == false
            item.update(active?: true)
            item.save
        end
        flash[:success] = "#{item.name} has been updated"
        redirect_to "/merchant/items"
    end

    def destroy
        item = Item.find(params[:id])
        item.reviews.destroy_all
        item.destroy
        flash[:success] = "#{item.name} has been deleted"
        redirect_to "/merchant/items"
    end
end