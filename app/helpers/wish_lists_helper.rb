module WishListsHelper
  def inspired_by(item)
    content_tag(:p, class: "text-info") do
      if item.user.present?
        item.user.name
      else
        "I Inspired!"
      end
    end
  end
end
