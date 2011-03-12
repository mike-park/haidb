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

require 'csv'

class Angel < ActiveRecord::Base
  acts_as_audited
  geocoded_by :full_address, :latitude  => :lat, :longitude => :lng
  
  after_initialize :set_default_values
  before_save :sanitize_fields, :update_display_name
  before_save :geocode, :if => :geocode_required?

  FEMALE = 'Female'
  MALE = 'Male'
  GENDERS = [FEMALE, MALE]

  has_many :registrations, :inverse_of => :angel, :dependent => :destroy
  has_many :events, :through => :registrations

  #default_scope order('LOWER(first_name) asc')
  scope :by_last_name, order('LOWER(last_name) asc')

  validates_presence_of :first_name, :last_name, :email
  validates_inclusion_of :gender, { :in => GENDERS,
    :message => :select }

  CSV_FIELDS = %w(full_name email highest_level gender address postal_code city country home_phone mobile_phone work_phone)
  ADDRESS_FIELDS = [:address, :postal_code, :city, :country]
  
  def full_name
    [first_name, last_name].compact.join(" ")
  end

  # this gets auto-called when registrations or events change.
  def cache_highest_level
    level = registrations.highest_completed_level || 0
    if level != highest_level
      update_attribute(:highest_level, level)
    end
    level
  end

  def self.csv_header
    CSV_FIELDS.map { |f| f.humanize }
  end
  
  def self.to_csv(array)
    CSV.generate(:force_quotes => true, :encoding => 'utf-8') do |csv|
      csv << csv_header
      array.each do |a|
        csv << a.get_fields(CSV_FIELDS)
      end
    end
  end
  
  def get_fields(fields)
    fields.map { |f| self.send(f) }
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
        if (value = read_attribute("#{ptype}_phone")).present?
          maker.add_tel(value) { |p| p.location = ptype }
        end
      end

      maker.add_note(notes) if notes.present?
    end.to_s
  end

  def self.merge_and_delete_duplicates
    Angel.group(:email).having('count(*) > 1').each do |possible|
      merge_and_delete_duplicates_of(possible)
    end
  end
  
  def self.merge_and_delete_duplicates_of(angel)
    matched_angels = find_duplicates_of(angel)
    base = matched_angels.shift
    if matched_angels.any?
      matched_angels.each do |angel|
        base.attributes = angel.attributes.except(:highest_level)
        # iterate as the same person (in two different angel records)
        # might be registered for the same event. this ignores registrations
        # that can't be transfered, they will be destroyed when the dup angel
        # is destroyed below
        angel.registrations.each do |r|
          base.registrations << r
        end
        base.save!
      end
      Angel.destroy(matched_angels)
      base.cache_highest_level
    end
    matched_angels.count
  end

  private

  def self.find_duplicates_of(angel)
    Angel.where("LOWER(email) = ?", angel.email.downcase).
      where("LOWER(last_name) = ?", angel.last_name.downcase).
      where("LOWER(first_name) = ?", angel.first_name.downcase).
      order('id').all
  end

  def set_default_values
    self.lang ||= I18n.locale.to_s
  end

  def sanitize_fields
    self.first_name = first_name.strip
    self.last_name = last_name.strip
    self.email = email.downcase.strip
  end

  def full_address
    ADDRESS_FIELDS.map {|field| read_attribute(field)}.compact.join(", ")
  end

  def geocode_required?
    fields_changed = ADDRESS_FIELDS.select { |f| changed_attributes[f.to_s] }
    fields_changed.any? || lat.nil? || lng.nil?
  end
  
  # only update if necessary, to avoid extra database traffic
  def update_display_name
    name = [last_name, first_name].reject { |i| i.blank? }.join(", ")
    name = [name, city].reject {|i| i.blank? }.join(" - ")
    self.display_name = name if name != display_name
  end
  
end
