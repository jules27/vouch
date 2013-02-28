class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      # TODO: how to ensure they log in successfully
      session["devise.facebook_data"] = @user.attributes #request.env["omniauth.auth"]
      flash[:notice] = "Facebook sign-in successful. Please fill out the rest of the information to finish the registration."
      redirect_to new_user_registration_url
    end
  end
end