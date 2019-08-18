class ReviewsController<ApplicationController

  def new
    @item = Item.find(params[:item_id])
  end

  def create
    item = Item.find(params[:item_id])
    item.reviews.create(review_params)
    redirect_to "/items/#{item.id}"
  end

  private

  def review_params
    params.permit(:title,:content,:rating)
  end
end
