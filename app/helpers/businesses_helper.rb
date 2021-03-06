module BusinessesHelper
  def reviews_numerical(business)
    "#{business.yelp_rating} Stars, #{business.yelp_review_count} Reviews"
  end

  def image(business)
    if business.image_url.present?
      image_tag business.image_url, class: "img-polaroid"
    else
      image_tag "default_business_image.gif", class: "img-polaroid"
    end
  end

  def display_phone(business)
    if business.phone.nil?
      "N/A"
    else
      business.phone
    end
  end

  def category_options
    [
      "",
      "American",
      "Asian Fusion",
      "Barkeries",
      "Bars",
      "Breakfast",
      "Brunch",
      "Burgers",
      "Burmese",
      "Cafes",
      "Cajun",
      "Chinese",
      "Coffee",
      "Creperies",
      "Delis",
      "Fast Food",
      "French",
      "Gluten-Free",
      "Italian",
      "Japanese",
      "Korean",
      "Lounges",
      "Mediterranean",
      "Mexican",
      "Modern European",
      "Persian",
      "Pizza",
      "Sandwiches",
      "Seafood",
      "Soul Food",
      "Spanish",
      "Specialty Food",
      "Steakhouses",
      "Sushi",
      "Tea",
      "Thai",
      "Vegan",
      "Vegetarian",
      "Vietnamese",
      "Wine Bars"
    ]
  end

  def us_states
    [
      ['AK', 'AK'],
      ['AL', 'AL'],
      ['AR', 'AR'],
      ['AZ', 'AZ'],
      ['CA', 'CA'],
      ['CO', 'CO'],
      ['CT', 'CT'],
      ['DC', 'DC'],
      ['DE', 'DE'],
      ['FL', 'FL'],
      ['GA', 'GA'],
      ['HI', 'HI'],
      ['IA', 'IA'],
      ['ID', 'ID'],
      ['IL', 'IL'],
      ['IN', 'IN'],
      ['KS', 'KS'],
      ['KY', 'KY'],
      ['LA', 'LA'],
      ['MA', 'MA'],
      ['MD', 'MD'],
      ['ME', 'ME'],
      ['MI', 'MI'],
      ['MN', 'MN'],
      ['MO', 'MO'],
      ['MS', 'MS'],
      ['MT', 'MT'],
      ['NC', 'NC'],
      ['ND', 'ND'],
      ['NE', 'NE'],
      ['NH', 'NH'],
      ['NJ', 'NJ'],
      ['NM', 'NM'],
      ['NV', 'NV'],
      ['NY', 'NY'],
      ['OH', 'OH'],
      ['OK', 'OK'],
      ['OR', 'OR'],
      ['PA', 'PA'],
      ['RI', 'RI'],
      ['SC', 'SC'],
      ['SD', 'SD'],
      ['TN', 'TN'],
      ['TX', 'TX'],
      ['UT', 'UT'],
      ['VA', 'VA'],
      ['VT', 'VT'],
      ['WA', 'WA'],
      ['WI', 'WI'],
      ['WV', 'WV'],
      ['WY', 'WY']
    ]
  end
end
