class Incognito
  def self.apply
    Angel.all.each do |angel|
      attrs = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          address: Faker::Address.street_address,
      }
      [:home_phone, :work_phone, :mobile_phone].each do |name|
        attrs[name] = Faker::PhoneNumber.phone_number if angel.send(name).present?
      end
      angel.update_columns(attrs)
      angel.send(:update_display_name)
      angel.update_columns(display_name: angel.display_name, email: Faker::Internet.email(angel.full_name))
      angel.registrations.update_all(attrs)
      angel.members.update_all(full_name: angel.full_name)
    end
  end
end