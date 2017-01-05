class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :notice, :warning, :danger, :info
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  layout :layout_by_resource
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  def layout_by_resource
    if devise_controller? && !user_signed_in?
      "application"
    else
      "app"
    end
  end
end
