module CapybaraMacros

  def office_login(user_type = nil)
    before(:each) do
      user = Factory.create(user_type || :staff)
      visit destroy_staff_session_path
      visit new_staff_session_path
      within("#staff_new") do
        fill_in 'staff[email]', :with => user.email
        fill_in 'staff[password]', :with => user.password
      end
      click_button 'staff_submit'
    end
  end
    
end
