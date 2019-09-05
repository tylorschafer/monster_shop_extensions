class UsersController <ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to "/profile"
    else
      flash[:error] = user.errors.full_messages.uniq.to_sentence
      redirect_to '/register'
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def show
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update(profile_params)
      flash[:success] = 'Profile updated'
      redirect_to '/profile'
    else
      flash[:error] = @user.error.full_messages.uniq.to_sentence
      redirect_to '/profile/edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:address,:city,:state,:zip,:email,:password,:password_confirmation)
  end

  def profile_params
    params.require(:users_edit).permit(:name,:address,:city,:state,:zip,:email)
  end
end
