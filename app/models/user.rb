class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Make it omniauthable for Facebook
  # devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :vouch_lists, foreign_key: "owner_id"
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation,
                  :remember_me, :admin, :provider, :uid, :gender, :location, :token, :image

  validates_presence_of   :email, :first_name, :last_name, :password, :password_confirmation
  validates_uniqueness_of :email

  after_create :check_current_shared_lists

  def name
    "#{first_name} #{last_name}"
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def restaurant_lists_by_city(city_name)
    city = City.find_by_name(city_name)
    vouch_lists.select { |list| list.city_id == city.id }
  end

  def admin?
    admin == true
  end

  def has_lists?
    vouch_lists.count > 0
  end

  def friends_with?(friend)
    friendships.where(friend_id: friend.id).present?
  end

  private

  def check_current_shared_lists
    # After a user has signed up, check to see if their name/email belong to
    # any other person's lists. If so, add this user to the other person's
    # friend list.
    VouchList.all.each do |list|
      next if list.owner.id == self.id
      list.shared_friends.each do |shared_friend|
        if shared_friend.email == self.email
          friendship = list.owner.friendships.build(friend_id: self.id)
          friendship.save
        end
      end
    end
  end

  # def facebook
  #   @facebook ||= Koala::Facebook::API.new(token)
  #   block_given? ? yield(@facebook) : @facebook
  # rescue Koala::Facebook::APIError
  #   logger.info e.to_s
  #   nil
  # end

  # def fb_friends
  #   facebook { |fb| fb.get_connection("me", "friends") }
  # end

  # def fb_friends_count
  #   facebook { |fb| fb.get_connection("me", "friends").size }
  # end

  # def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
  #   puts "*************"
  #   puts "provider = = #{auth.provider}"
  #   puts "token = #{auth.credentials.token}"
  #   puts "uid = #{auth.uid}"
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.provider   = auth.provider
  #     user.uid        = auth.uid
  #     user.token      = auth.credentials.token
  #     user.email      = auth.info.email
  #     user.first_name = auth.extra.raw_info.first_name
  #     user.last_name  = auth.extra.raw_info.last_name
  #     user.gender     = auth.extra.raw_info.gender
  #     user.location   = auth.info.location
  #     user.image      = auth.info.image
  #     user.password   = Devise.friendly_token[0,20]
  #     user.password_confirmation = user.password
  #   end
  # end

end
