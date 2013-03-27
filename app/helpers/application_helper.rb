module ApplicationHelper
  def facebook_login_link
    link_to "Sign in with Facebook", user_omniauth_authorize_path(:facebook)
  end

  def facebook_login_banner
    link_to "Sign In with Facebook", user_omniauth_authorize_path(:facebook), class: "btn-auth btn-facebook large"
  end

  # Supposed to come with twitter bootstrap, but is throwing an error
  # when deployed to Heroku
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

  def nav_link(text, path)
    class_name = current_page?(path) ? "active" : ""
    content_tag(:li, class: class_name) do
      link_to text, path
    end
  end

  def add_friend_link
    link_to "Please add some by sharing a list!", vouch_lists_path
  end

  def add_new_business_link(type_name = "restaurant")
    link_to "Don't see your restaurant? Help us to add one.", new_business_by_type_path("restaurant")
  end

  def already_vouched_button(custom_class = "success")
    content_tag(:button, class: "btn btn-#{custom_class} disabled") do
      "Already Vouched!"
    end
  end

  def already_in_wish_list_button(custom_class = "info")
    content_tag(:button, class: "btn btn-#{custom_class} disabled") do
      "Already In Your Wish List!"
    end
  end
end
