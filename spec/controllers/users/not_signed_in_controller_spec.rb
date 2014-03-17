# -*- coding: utf-8 -*-
require 'spec_helper'

describe Users::NotSignedInController do
  [:signup_requested, :confirmed].each do |name|
    it "#{name} should not require a login" do
      get name
      response.should be_success
    end
  end
end
