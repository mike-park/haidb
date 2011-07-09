require "spec_helper"

describe Site do
  context "site defaults" do
    if Site.uk?
      it { Carmen.default_country.should == 'GB' }
      it { Site.thankyou_url.should match("www.hai-uk.org.uk") }
    end

    if Site.de?
      it { Carmen.default_country.should == 'DE' }
      context "thank you page" do
        it "should be German" do
          I18n.locale = :de
          Site.thankyou_url.should == "http://www.liebstduschon.de/lds/index.php?id=20x0"
        end
        it "should be English" do
          I18n.locale = :en
          Site.thankyou_url.should == "http://www.liebstduschon.de/lds/index.php?id=20x1"
        end
      end
    end
  end
end

