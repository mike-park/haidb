class Incognito
  def self.apply
    Angel.all.each do |angel|
      angel.update_column(:first_name, Faker::Name.first_name)
      angel.update_column(:last_name, Faker::Name.last_name)
      angel.update_column(:address, Faker::Address.street_address)
      angel.update_column(:email, Faker::Internet.email(angel.full_name))
      angel.send(:update_display_name)
      angel.update_column(:display_name, angel.display_name)
    end
  end
end