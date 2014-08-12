class Message < ActiveRecord::Base
  SEPARATOR = ','

  belongs_to :source, polymorphic: true
  belongs_to :staff

  validates_presence_of :subject, :message, :to_list, :from

  scope :by_most_recent, -> { order("created_at desc") }

  def to
    to_list.to_s.split(SEPARATOR)
  end

  def cc
    cc_list.to_s.split(SEPARATOR)
  end

  def bcc
    bcc_list.to_s.split(SEPARATOR)
  end

  def recipients
    to + cc + bcc
  end
end