# -*- coding: utf-8 -*-
require 'spec_helper'

describe Users::Devise::RegistrationsController do

  context 'POST create' do
    let(:password) { "123456789" }
    let(:valid_registration_attributes) { { user: { email: 'a@example.com', password: password, password_confirmation: password}}}

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, valid_registration_attributes
    end

    it "should send confirmation email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
    it "should redirect to signup path" do
      response.should redirect_to(users_signup_requested_path)
    end
  end

end

