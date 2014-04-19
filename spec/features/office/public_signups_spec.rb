# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'site_defaults' do
  let(:public_signup) { create(:public_signup) }

  before do
    public_signup
    office_login
  end

  context "public_signup workflow" do
    it "should wait list signup" do
      visit office_root_path
      click_link 'Public Signups'
      click_link 'Pending'
      click_link public_signup.full_name
      click_link 'Waitlist'
      expect(page).to have_content('0 Pending signups')
      click_link 'Public Signups'
      click_link 'Wait List'
      expect(page).to have_content(public_signup.full_name)
      expect(PublicSignup.waitlisted).to eq([public_signup])
    end

    it "should approve a pending signup" do
      visit office_root_path
      click_link 'Public Signups'
      click_link 'Pending'
      click_link public_signup.full_name
      click_link 'Approve'
      expect(page).to have_content('0 Pending signups')
      click_link 'Public Signups'
      click_link 'Approved'
      expect(page).to have_content(public_signup.full_name)
      expect(PublicSignup.approved).to eq([public_signup])
    end

    it "should approve a wait listed signup" do
      public_signup.waitlist!

      visit office_root_path
      click_link 'Public Signups'
      click_link 'Wait List'
      click_link public_signup.full_name
      click_link 'Approve'
      expect(page).to have_content('0 Pending signups')
      click_link 'Public Signups'
      click_link 'Approved'
      expect(page).to have_content(public_signup.full_name)
      expect(PublicSignup.approved).to eq([public_signup])
    end
  end
end
