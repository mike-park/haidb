require 'spec_helper'

describe Mappable do
  let(:reg) { build(:registration) }

  context "normal test mode" do
    it "should not geocode" do
      Gmaps4rails.should_not_receive(:geocode)
      reg.save
    end
  end

  context "as if not in test mode" do
    before do
      Registration.stub(disable_mappable: false)
    end

    it "should geocode" do
      Gmaps4rails.should_receive(:geocode).and_return([{}])
      reg.save
    end

    it 'should access the full_address on save' do
      Gmaps4rails.should_receive(:geocode).and_return([{}])
      reg.should receive(:full_address)
      reg.save!
    end

    it "should be geocoded?" do
      reg.should_not be_geocoded
      reg.lat = reg.lng = 1
      reg.should be_geocoded
    end

    it "should not geocode" do
      reg.lat = reg.lng = 1
      reg.last_name = 'foo'
      Gmaps4rails.should_not_receive(:geocode)
      reg.save
    end

    it "should geocode" do
      reg.lat = reg.lng = 1
      Gmaps4rails.should_receive(:geocode).exactly(5).and_return([{}])
      [:last_name, :address, :city, :postal_code, :country, :first_name].each do |name|
        reg.send("#{name}=", name)
        reg.save
      end
    end

    # it "should geocode to real values" do
    #   # accesses google. might temporarily fail
    #   reg.update_attributes(city: 'Berlin', country: 'DE')
    #   reg.lat.should be_within(0.5).of(52.52)
    #   reg.lng.should be_within(0.5).of(13.40)
    # end
  end
end