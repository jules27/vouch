class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Make it omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation,
                  :remember_me, :admin, :provider, :uid, :gender, :location, :token

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

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    puts "*************"
    puts "provider = = #{auth.provider}"
    puts "token = #{auth.credentials.token}"
    puts "uid = #{auth.uid}"
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider   = auth.provider
      user.uid        = auth.uid
      user.token      = auth.credentials.token
      user.email      = auth.info.email
      user.first_name = auth.extra.raw_info.first_name
      user.last_name  = auth.extra.raw_info.last_name
      user.gender     = auth.extra.raw_info.gender
      user.location   = auth.info.location
      user.image      = auth.info.image
      user.password   = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
  end

end
