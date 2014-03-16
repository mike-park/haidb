class PromoteAngel < ActiveRecord::Migration
  ANGEL_FIELDS = [:first_name, :last_name, :gender, :address, :postal_code, :city, :country, :email, :home_phone,
                   :mobile_phone, :work_phone, :lang]
  REG_FIELDS = [:highest_level, :highest_location, :highest_date, :registration_code]
  STRING_FIELDS = ANGEL_FIELDS + REG_FIELDS

  REG1_FIELDS = [:payment_method, :bank_account_name, :iban, :bic]

  def up
    STRING_FIELDS.each do |name|
      add_column(:registrations, name, :string)
    end
    add_column(:registrations, :lat, :float)
    add_column(:registrations, :lng, :float)
    change_column(:registrations, :angel_id, :integer, null: true)
    REG1_FIELDS.each do |name|
      add_column(:angels, name, :string)
    end

    migrate_data
    validate_transfer
  end

  def down
    remove_columns(:registrations, *STRING_FIELDS)
    remove_columns(:registrations, :lat, :lng)
    change_column(:registrations, :angel_id, :integer, null: false)

    remove_columns(:angels, *REG1_FIELDS)
  end

  def migrate_data
    Registration.reset_column_information
    Angel.reset_column_information

    angel_fields = (STRING_FIELDS + [:lng, :lat]).map(&:to_s)
    reg1_fields = REG1_FIELDS.map(&:to_s)
    Registration.order('id asc').each do |r|
      angel = r.angel
      r.update_attributes!(angel.attributes.slice(*angel_fields).merge(r.options))
      angel.update_attributes!(r.attributes.slice(*reg1_fields))
    end
  end

  def validate_transfer
    v1 = Registration.all.map {|r| r.options[:registration_code]}
    v2 = Registration.all.map(&:registration_code)
    puts "Invalid registration codes\n=====\n#{v1}\n======\n#{v2}\n" unless v1 == v2
  end

  class Registration < ActiveRecord::Base
    belongs_to :angel
    store :options
  end

  class Angel < ActiveRecord::Base
    has_many :registrations
  end
end
