require 'spec_helper'

describe 'registration' do
  let(:user) { build(:user) }

  it "should allow registration" do
    visit users_root_path
    click_on 'signup-link'
    within("#new_user") do
      fill_in 'user[email]', :with => user.email
      fill_in 'user[password]', :with => user.password
      fill_in 'user[password_confirmation]', :with => user.password
    end
    click_on 'signup-button'
    page.should have_css('.not_signed_in.signup_requested')
    expect(User.first.email).to eql(user.email)
  end

  it "should confirm registration" do
    user.save!
    open_last_email
    click_first_link_in_email
    page.should have_css('.not_signed_in.confirmed')
  end

  context "after confirmation login" do
    let(:angel) { build(:angel, email: email) }

    before do
      angel.save!
      user.save!
      open_last_email
      click_first_link_in_email
      click_on 'signin-button'
      within("#new_user") do
        fill_in 'user[email]', :with => user.email
        fill_in 'user[password]', :with => user.password
      end
      click_on 'signin-button'
    end

    context "without matching angel" do
      let(:email) { 'doesnotmatch@example.com' }

      it "should prompt for profil information" do
        page.should have_css('.angels.new')
      end
    end

    context "with matching angel" do
      let(:email) { user.email }

      it "should go to dashboards index" do
        page.should have_css('.dashboards.index')
      end
    end
  end
end
