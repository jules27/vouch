require 'oauth'
require 'json'

module YelpHelper
  def self.api_host
    'api.yelp.com'
  end

  def self.api_search_path
    '/v2/search'
  end

  def self.consumer
    @consumer ||= OAuth::Consumer.new(Settings.yelp_consumer_key, Settings.yelp_consumer_secret, {:site => "http://#{api_host}"})
  end

  def self.access_token
    @access_token ||= OAuth::AccessToken.new(consumer, Settings.yelp_token, Settings.yelp_token_secret)
  end

  def self.path(location)
    "#{api_search_path}?term=restaurant&ll=#{location}&radius_filter=3000"
  end

  def self.query(location)
    access_token.get(path(location)).body
  end

  def self.businesses(location)
    JSON.parse(query(location))["businesses"] || []
  end

  def self.get_businesses(location)
    businesses(location).collect do |business|
    {
      name:     business['name'],
      phone:    business['phone'],
      address_line_1: business['location']['address'].first,
      address_line_2: business['location']['address'].second,
      city:     business['location']['city'],
      state:    business['location']['state_code'],
      zip:      business['location']['postal_code'],
      neighborhood: business['location']['neighborhoods'].join(", "),
      categories:   business['categories'].flatten,
      yelp_id:      business['id'],
      yelp_rating:  business['rating'],
      yelp_review_count: business['review_count'],
      yelp_url:   business['url'], # not currently used in model
      image_url:  business['image_url'],
      distance:   business['distance'], # not currently used in model
      latitude:   business['location']['coordinate']['latitude'],
      longitude:  business['location']['coordinate']['longitude'],
    }
    end
  end

  def self.region(location)
    JSON.parse(query(location))["region"] || []
  end

  def self.get_region(location)
    info = region(location)
    {
      latitude_delta:  info['span']['latitude_delta'],
      longitude_delta: info['span']['longitude_delta'],
      latitude:        info['center']['latitude'],
      longitude:       info['center']['longitude'],
    }
  end

  def self.search(location)
    location ||= "37.77509,-122.39832"
    # { businesses: get_businesses(location), region: get_region(location) }
    get_businesses(location)
  end
end