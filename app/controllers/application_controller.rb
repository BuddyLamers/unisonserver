class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  before_filter :require_user

  def logged_in?
    current_user.present?
  end

  # session[:user_id] set on sessions#create.
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user ||= authenticate_with_http_token do |token, options|
        User.with_token(token)
      end
    end
  end

  def require_user
    unless logged_in? and current_user.can_use_site?
      respond_to do |format|
        format.json do
          render json: {error: :bad_token}
        end
        format.html do
          store_location
          redirect_to login_path
        end
      end
    end
  end

  def store_location
    session[:stored_path] = request.fullpath
  end

  def return_to_stored_location
    redirect_to session.delete(:stored_path) || home_path
  end
end

