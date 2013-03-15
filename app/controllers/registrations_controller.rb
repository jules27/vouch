class RegistrationsController < Devise::RegistrationsController
  def edit
    @city = current_user.default_city
  end

  def update
    @user = User.find(current_user.id)

    # Password can be left blank
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      params[:user].delete(:current_password)
      user = @user.update_without_password(params[:user])
    else
      params[:user].delete(:current_password)
      user = @user.update_attributes(params[:user])
    end
    
    if user
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      clean_up_passwords @user
      render "edit"
    end
  end
end