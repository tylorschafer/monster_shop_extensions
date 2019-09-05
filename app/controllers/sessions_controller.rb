class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to "/#{user.role}/profile"
    else
      flash[:error] = "Invalid Email or Password"
      redirect_to '/login'
    end
  end

  def end
    session[:user_id] = nil
    flash[:success] = "L8r, yo"
    redirect_to "/"
  end
end
