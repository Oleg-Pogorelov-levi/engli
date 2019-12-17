class UsersController < ApplicationController

  def show
	@user = User.friendly.find(params[:id])
	@phrases = @user.phrases.paginate(:page => params[:page], :per_page => 10)
  end

  def index
	@users = User.order(carma: :desc).paginate(:page => params[:page])
  end

end
