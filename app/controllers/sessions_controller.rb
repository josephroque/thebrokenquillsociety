class SessionsController < ApplicationController

  # Only allowed logged out users to access certain pages
  before_action :logged_out_user, only: [:new, :create]

  # Form to let a user login to their account
  def new
  end

  # Creates a new user session
  def create
    user = User.find_by(email: params[:session][:email].downcase)

    # If the user exists and the password entered is valid
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash[:error] = 'Your email or password is incorrect.'
      render 'new'
    end
  end

  # Closes a session when the user logs out
  def destroy
    log_out if logged_in?
    flash[:success] = 'You have been successfully logged out.'
    redirect_to root_path
  end

end
