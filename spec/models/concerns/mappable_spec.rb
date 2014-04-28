require 'spec_helper'

describe Mappable do
  let(:reg) { build(:registration, address: 'address', city: 'city') }

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
      reg.should receive(:full_address)
      reg.save
    end

    context "with a geocoded registation" do
      before do
        reg.save!
      end

      it "should be geocoded?" do
        reg.should be_geocoded
      end


      it "should not geocode with non address changes" do
        Gmaps4rails.should_not_receive(:geocode)
        [:first_name, :last_name].each do |name|
          reg.send("#{name}=", name)
          reg.save
        end
      end

      it "should geocode with address change" do
        Gmaps4rails.should_receive(:geocode).exactly(4).and_return([{}])
        [:address, :city, :postal_code, :country].each do |name|
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
end