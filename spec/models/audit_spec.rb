# -*- coding: utf-8 -*-
require 'spec_helper'

describe Audit do
  let(:angel) { Factory.create(:angel, :home_phone => '1', :email => 'me@somewhere.com') }

  it { angel.home_phone.should == '1' }
  it { angel.email.should == 'me@somewhere.com' }
  it { angel.audits.count.should == 1 }

  context "changing a field to the same value" do
    before(:each) do
      angel.home_phone = '1'
      angel.email == 'me@somewhere.com'
      angel.save!
    end

    it { angel.home_phone.should == '1' }
    it { angel.email.should == 'me@somewhere.com' }
    it { angel.audits.count.should == 1 }
    
  end
end
