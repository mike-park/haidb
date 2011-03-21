# == Schema Information
# Schema version: 20110320131630
#
# Table name: admins
#
#  id                   :integer         primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :timestamp
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :timestamp
#  last_sign_in_at      :timestamp
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :timestamp
#  confirmation_sent_at :timestamp
#  failed_attempts      :integer         default(0)
#  unlock_token         :string(255)
#  locked_at            :timestamp
#  authentication_token :string(255)
#  created_at           :timestamp
#  updated_at           :timestamp
#

class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable, :confirmable
  devise :database_authenticatable, :trackable, :validatable,
         :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
