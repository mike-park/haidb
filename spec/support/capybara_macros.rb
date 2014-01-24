module CapybaraMacros

  def office_login
    before(:each) do
      user = FactoryGirl.create(:staff)
      visit office_root_path
      within("#new_staff") do
        fill_in 'staff[email]', :with => user.email
        fill_in 'staff[password]', :with => user.password
      end
      click_button 'Sign in'
    end
  end

  def users_login
    before(:each) do
      user = FactoryGirl.build(:user)
      user.skip_confirmation!
      user.save!
      visit users_root_path
      within("#new_user") do
        fill_in 'user[email]', :with => user.email
        fill_in 'user[password]', :with => user.password
      end
      click_button 'Sign in'
    end
  end

end
