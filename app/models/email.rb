class Email < ActiveRecord::Base
  audited

  belongs_to :email_name

  validates_presence_of :locale, :subject, :body
  validates_uniqueness_of :locale, :scope => :email_name_id

  scope :by_locale, -> { order('locale asc') }
end