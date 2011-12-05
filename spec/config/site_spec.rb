require "spec_helper"

describe Site do
  context "site defaults" do
    context "uk" do
      before(:each) { Site.stub(:name).and_return('uk') }

      it { Site.default_country.should == 'GB' }
      it { Site.thankyou_url.should match("www.hai-uk.org.uk") }
    end

    context "de" do
      before(:each) { Site.stub(:name).and_return('de') }

      it { Site.default_country.should == 'DE' }

      context "thank you page" do
        context "de" do
          before(:each) { I18n.locale = :de }
          it "should be German" do
            Site.thankyou_url.should == "http://www.liebstduschon.de/lds/index.php?id=20x0"
          end
        end

        context "en" do
          before(:each) { I18n.locale = :en }
          it "should be English" do
            Site.thankyou_url.should == "http://www.liebstduschon.de/lds/index.php?id=20x1"
          end
        end
      end

    end
  end
end

