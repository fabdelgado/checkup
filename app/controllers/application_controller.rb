class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :force_http
  before_action :authorize

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    nil
  end
  helper_method :current_user

  def counter
    @counter ||= Counter.recent.first_or_initialize
  end
  helper_method :counter

  def authorize
    unless current_user
      redirect_to root_url, alert: "Not Authorized"
    end
  end

  def force_http
    if request.ssl?
      redirect_to protocol: 'http://', status: 301
    end
  end
end
