class SessionController < ApplicationController
  skip_before_filter :require_user

  def new

  end

  def auth
    @user = User.auth(params[:email], params[:password])

    respond_to do |format|
      if @user
        session[:user_id] = @user.id
        format.html do
          return_to_stored_location
          # redirect_to root_path, notice: "You are logged in as #{user.email}."
        end
        format.json {render json: {teacher: @user.person, token: @user.token, uid: @user.id}, status: :ok, location: @user}
      else
        format.html {redirect_to login_path, alert: "Email or password is invalid."}
        format.json {render json: {error: "Invalid email or password."}, status: :failed}
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out."
  end

end

