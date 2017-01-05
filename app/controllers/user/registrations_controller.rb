class User::RegistrationsController < Devise::RegistrationsController
  layout 'app', only: [:edit]
  
  before_filter :configure_permitted_parameters

  def edit
    super
  end

  protected 
  
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :unit_type, :name)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
 