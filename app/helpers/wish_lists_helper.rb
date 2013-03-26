module WishListsHelper
  def inspired_by(item)
    # content_tag(:p, class: "text-info") do
    label_class = item.user.present? ? "label-success" : "label-info"
    content_tag(:span, class: "label #{label_class}") do
      if item.user.present?
        item.user.name
      else
        "I Inspired!"
      end
    end
  end
end
