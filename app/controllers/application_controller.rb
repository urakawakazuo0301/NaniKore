class ApplicationController < ActionController::Base

  include Pundit::Authorization 

  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    root_path
  end
  
  private

  def user_not_authorized
    flash[:alert] = "この操作を行う権限がありません。"
    redirect_to(request.referrer || root_path)
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

end
