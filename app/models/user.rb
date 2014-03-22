class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :invitable, :database_authenticatable, :lockable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  belongs_to :angel, inverse_of: :users
  has_many :registrations, through: :angel
  has_many :events, :through => :registrations
  has_many :memberships, through: :angel


  def self.move_to(angel, ids)
    where(id: ids).update_all(angel_id: angel.id) if ids.any?
  end

  def full_name
    angel ? angel.full_name : email
  end

  def active_membership?
    angel && angel.active_membership
  end

  private

  def after_confirmation
    super
    attach_angel unless angel
  end

  def attach_angel
    self.angel = Angel.by_email(email).first
    save!
  end
end
