class Message
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  SEPARATOR = ','
  ATTRIBUTES = [:subject, :message, :to_list, :cc_list, :bcc_list, :from, :header, :footer]
  attr_accessor *ATTRIBUTES

  validates_presence_of :subject, :message, :to_list, :from

  def initialize(attrs = {})
    ATTRIBUTES.each do |name|
      send("#{name}=", attrs[name]) if attrs.has_key?(name)
    end
  end

  def to
    to_list.to_s.split(SEPARATOR)
  end

  def cc
    cc_list.to_s.split(SEPARATOR)
  end

  def bcc
    bcc_list.to_s.split(SEPARATOR)
  end
end