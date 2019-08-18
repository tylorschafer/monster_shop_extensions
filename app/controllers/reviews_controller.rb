class ReviewsController<ApplicationController

  def new
    @item = Item.find(params[:item_id])
  end

  def create
    if field_empty?
      item = Item.find(params[:item_id])
      flash[:failure] = "Please fill in all fields in order to create a review."
      redirect_to "/items/#{item.id}/reviews/new"
    else
      item = Item.find(params[:item_id])
      item.reviews.create(review_params)
      redirect_to "/items/#{item.id}"
    end
  end

  private

  def review_params
    params.permit(:title,:content,:rating)
  end

  def field_empty?
    params = review_params
    params[:title].empty? || params[:content].empty? || params[:rating].empty?
  end
end
