class Email < ActiveRecord::Base
  audited

  belongs_to :email_name

  validates_presence_of :locale, :subject, :body
  validates_uniqueness_of :locale, :scope => :email_name_id
end


# == Schema Information
#
# Table name: emails
#
#  id            :integer         not null, primary key
#  email_name_id :integer
#  locale        :string(255)
#  subject       :string(255)
#  body          :text
#  created_at    :datetime
#  updated_at    :datetime
#

