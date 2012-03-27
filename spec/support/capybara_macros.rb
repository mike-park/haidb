module CapybaraMacros

  def office_login
    before(:each) do
      user = Factory.create(:staff)
      visit office_path
      within("#new_staff") do
        fill_in 'staff[email]', :with => user.email
        fill_in 'staff[password]', :with => user.password
      end
      click_button 'Sign in'
    end
  end
    
end
