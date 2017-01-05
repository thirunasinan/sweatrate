class PagesController < ApplicationController
  def index
    if !current_user
      redirect_to '/users/sign_in'
    else
      redirect_to '/dashboard'
    end
  end
end