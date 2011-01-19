# == Schema Information
# Schema version: 20110114122352
#
# Table name: angels
#
#  id            :integer         not null, primary key
#  display_name  :string(255)     not null
#  first_name    :string(255)
#  last_name     :string(255)     not null
#  gender        :string(255)     not null
#  address       :string(255)
#  postal_code   :string(255)
#  city          :string(255)
#  country       :string(255)
#  email         :string(255)     not null
#  home_phone    :string(255)
#  mobile_phone  :string(255)
#  work_phone    :string(255)
#  lang          :string(255)     default("en")
#  notes         :text
#  created_at    :datetime
#  updated_at    :datetime
#  highest_level :integer         default(0)
#

class Angel < ActiveRecord::Base
  geocoded_by :full_address, :latitude  => :lat, :longitude => :lng
  
  before_save :update_display_name

  FEMALE = 'Female'
  MALE = 'Male'
  GENDERS = [FEMALE, MALE]

  has_many :registrations, :inverse_of => :angel, :dependent => :destroy
  has_many :events, :through => :registrations

  #default_scope order('LOWER(first_name) asc')
  scope :by_last_name, order('LOWER(last_name) asc')

  validates_presence_of :last_name, :email
  validates_inclusion_of :gender, { :in => GENDERS,
    :message => :select }

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def full_address
    [address, postal_code, city, country].compact.join(", ")
  end
  
  def display_phones
    phones = []
    phones << "H: #{home_phone}" unless home_phone.blank?
    phones << "M: #{mobile_phone}" unless mobile_phone.blank?
    phones << "W: #{work_phone}" unless work_phone.blank?
    phones.join(", ")
  end

  # this gets auto-called when registrations or events change.
  # if our calculated level is < highest_level we keep the higher value
  # this assumes higher level was set by staff
  def update_highest_level
    level = registrations.completed.collect(&:level).compact.max || 0
    level = [level, highest_level].compact.max
    update_attribute(:highest_level, level) if level != highest_level
  end
  
  def self.to_vcard(array)
    array.map(&:to_vcard).join
  end

  def to_vcard
    Vpim::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        name.given = first_name || ''
        name.family = last_name || ''
      end

      maker.add_addr do |addr|
        addr.preferred = true
        addr.location = 'home'
        addr.street = address || ''
        addr.postalcode = postal_code || ''
        addr.locality = city || ''
        addr.country = country || ''
      end

      if email.present? && email != 'unknown'
        maker.add_email(email) { |e| e.location = 'home' }
      end

      %w(home mobile work).each do |ptype|
        if (value = read_attribute(ptype)).present?
          maker.add_tel(value) { |p| p.location = ptype }
        end
      end

      maker.add_note(notes) if notes.present?
    end.to_s
  end
  
  private

  # only update if necessary, to avoid extra database traffic
  def update_display_name
    name = [last_name, first_name].reject { |i| i.blank? }.join(", ")
    name = [name, city].reject {|i| i.blank? }.join(" - ")
    self.display_name = name if name != display_name
  end
  
end
