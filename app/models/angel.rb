class Angel < ActiveRecord::Base
  acts_as_audited except: [:gravatar, :highest_level, :lat, :lng]
  include Mappable
  include Vcardable
  include Csvable

  csv_fields :full_name, :email, :highest_level, :gender,
             :address, :postal_code, :city, :country,
             :home_phone, :mobile_phone, :work_phone, :notes

  before_save :sanitize_fields, :update_display_name, :update_gravatar

  has_many :registrations, :inverse_of => :angel, dependent: :nullify
  has_many :memberships, inverse_of: :angel, dependent: :destroy
  has_many :events, :through => :registrations
  has_one :user, inverse_of: :angel

  #default_scope order('LOWER(first_name) asc')
  scope :by_last_name, lambda { order('LOWER(last_name) asc') }
  scope :by_full_name, lambda { order('LOWER(first_name), LOWER(last_name), id asc') }
  scope :by_email, ->(email) { where(email: email.to_s.downcase) }
  # float compares don't really work
  scope :located_at, lambda {|lat, lng| where(lat: lat, lng: lng)}

  validates_presence_of :last_name, :email
  validates_inclusion_of :gender, :in => Registration::GENDERS, :message => :select, allow_nil: true

  REGISTRATION_FIELDS = [:first_name, :last_name, :email, :gender,
                         :address, :postal_code, :city, :country, :home_phone, :mobile_phone, :work_phone,
                         :lang, :payment_method, :bank_account_name, :iban, :bic].map(&:to_s).freeze

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def full_name_with_context
    [full_name, city].reject {|x| x.blank? }.join(" - ")
  end

  # this gets auto-called when registrations or events change.
  def cache_highest_level
    level = registrations.highest_completed_level || 0
    if level != highest_level
      update_attribute(:highest_level, level)
    end
    level
  end

  def self.merge_and_delete_duplicates
    find_angels_with_same_email_address.each do |possible|
      merge_and_delete_duplicates_of(possible)
    end
  end

  def self.merge_and_delete_duplicates_of(angel)
    matched_angels = find_duplicates_of(angel)
    MergeAngels.new(matched_angels.map(&:id)).invoke
  end

  def <=>(other)
    full_name_with_context.downcase <=> other.full_name_with_context.downcase
  end

  def self.add_to(registration)
    angel = Angel.by_email(registration.email).first_or_initialize
    Angel.transaction do
      angel.update_attributes!(registration.attributes.slice(*REGISTRATION_FIELDS))
      registration.update_attribute(:angel_id, angel.id)
    end
    angel
  end

  private

  def self.find_angels_with_same_email_address
    # this only works on sqlite, not pgsql
    #Angel.group(:email).having('count(*) > 1')
    Angel.all.group_by(&:email).select { |k,v| v.count > 1}.map { |k,v| v }.flatten.compact
  end

  def self.find_duplicates_of(angel)
    Angel.where("LOWER(email) = ?", angel.email.downcase).
      where("LOWER(last_name) = ?", angel.last_name.downcase).
      where("LOWER(first_name) = ?", angel.first_name.downcase).
      order('id').all
  end

  def sanitize_fields
    self.first_name = first_name.to_s.strip
    self.last_name = last_name.to_s.strip
    self.email = email.to_s.downcase.strip
  end

  # only update if necessary, to avoid extra database traffic
  def update_display_name
    name = [last_name, first_name].reject { |i| i.blank? }.join(", ")
    name = [name, city].reject {|i| i.blank? }.join(" - ")
    self.display_name = name if name != display_name
  end

  def update_gravatar
    self.gravatar = data_uri(Gravatar.new(email).image_data(rescue_errors: true, size: '40', rating: 'x', default: 'mm'))
  end

  def data_uri(data, type = "image/jpg")
    "data:" + type + ";base64," + Base64.encode64(data).rstrip if data.present?
  end
end
