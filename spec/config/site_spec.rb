require "spec_helper"

describe Site do
  context "site defaults" do
    context "uk" do
      before(:each) { Site.stub(:name).and_return('uk') }

      it { Site.default_country.should == 'GB' }
    end

    context "de" do
      before(:each) { Site.stub(:name).and_return('de') }

      it { Site.default_country.should == 'DE' }

    end
  end
end

