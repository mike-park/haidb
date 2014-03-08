# -*- coding: utf-8 -*-
require 'spec_helper'

describe Users::SignedUpController do

  context 'GET new' do
    it "should not require a login" do
      get :new
      response.should be_success
    end
  end

end

