class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :invitable, :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    # HACK ALERT
    ap access_token
    data = access_token.extra.raw_info
    self.where(:email => data.email).first
  end
end
