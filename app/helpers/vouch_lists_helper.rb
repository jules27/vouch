module VouchListsHelper
  def google_login_link(list_id)
    'https://accounts.google.com/o/oauth2/auth'\
    '?scope=https%3A%2F%2Fwww.google.com%2Fm8%2Ffeeds'\
    "&state=#{list_id}"\
    '&response_type=token'\
    '&client_id=1058703828317.apps.googleusercontent.com'\
    "&redirect_uri=http%3A%2F%2F#{Settings.domain}%2Foauth2callback"
  end

  def capitalize_title(title)
    title.slice(0,1).capitalize + title.slice(1..-1)
  end

  def has_ownership?(vouch_list)
    current_user.id == vouch_list.owner.id
  end

  def show_list_div_class(vouch_list)
    if has_ownership?(@vouch_list)
      "span6"
    else
      "span9"
    end
  end

  def rating_class(rating)
    (rating * 10).to_i
  end

  def business_image(business, link = nil)
    if business.yelp_id.present?
      if link.present?
        link_to image_tag(business.image_url, class: "img-polaroid"), link
      else
        link_to image_tag(business.image_url, class: "img-polaroid"), "http://www.yelp.com/biz/#{business.yelp_id}", target: "_blank"
      end
    else
      if business.image_url.present?
        image_tag b.image_url, class: "img-polaroid"
      else
        image_tag "default_business_image.gif", class: "img-polaroid"
      end
    end
  end

  def business_rating(business)
    if business.yelp_rating.present?
      content_tag(:span, class: "rating-static rating-#{rating_class(business.yelp_rating)}") do
      end
    else
      "Not Available"
    end
  end

  def business_review_count(business)
    if business.yelp_review_count.present?
      business.yelp_review_count
    else
      "0"
    end
  end

  def share_business_name(business)
    if business.yelp_id.present?
      link_to business.name, business_path(business)
    else
      business.name
    end
  end
end
