class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :invitable, :database_authenticatable, :lockable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

end
