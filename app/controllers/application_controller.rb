class ApplicationController < ActionController::Base
  protect_from_forgery

  # Methods required to use one model for devise and active admin.
  def authenticate_admin_user!
    authenticate_user! 
    unless current_user.admin?
      flash[:alert] = "This area is restricted to administrators only."
      redirect_to root_path 
    end
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  # def after_sign_in_path_for(resource)
  #  current_user_path
  # end
end
