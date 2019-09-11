class WelcomeController < ApplicationController
  def home
  end

  def catch_404
    raise ActionController::RoutingError.new(params[:path])
  end
end
