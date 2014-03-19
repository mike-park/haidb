# encoding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  it "should set correct currency unit" do
    Site.stub(:name).and_return('de')
    helper.local_currency(10).should == "10,00 €"
    Site.stub(:name).and_return('uk')
    helper.local_currency(10).should == "£10.00"
  end
end