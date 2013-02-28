module ApplicationHelper
  def facebook_login_link
    link_to "Sign in with Facebook", user_omniauth_authorize_path(:facebook)
  end

  def facebook_login_banner
    link_to "Sign In with Facebook", user_omniauth_authorize_path(:facebook), class: "btn-auth btn-facebook large"
  end
end
