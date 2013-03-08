class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Make it omniauthable for Facebook
  # devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation,
                  :remember_me, :admin, :provider, :uid, :gender, :location, :token, :image

  validates_presence_of   :email
  validates_uniqueness_of :email

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
