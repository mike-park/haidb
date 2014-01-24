require 'spec_helper'

describe 'Factories' do
  FactoryGirl.factories.map(&:name).each do |name|
    it "should save factory #{name}" do
      FactoryGirl.create(name)
    end
  end
end