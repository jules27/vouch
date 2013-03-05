module ApplicationHelper
  def facebook_login_link
    link_to "Sign in with Facebook", user_omniauth_authorize_path(:facebook)
  end

  def facebook_login_banner
    link_to "Sign In with Facebook", user_omniauth_authorize_path(:facebook), class: "btn-auth btn-facebook large"
  end

  # Supposed to come with twitter bootstrap
  ALERT_TYPES = [:error, :info, :success, :warning]
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if message
      end
    end
    flash_messages.join("\n").html_safe
  end
end
