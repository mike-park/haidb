require 'spec_helper'

describe Mappable do
  let(:reg) { build(:registration) }

  it 'should access the full_address on save' do
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
    reg.should_not receive(:full_address)
    reg.save
  end

  it "should geocode" do
    reg.lat = reg.lng = 1
    reg.should receive(:full_address).exactly(4)
    [:last_name, :address, :city, :postal_code, :country, :first_name].each do |name|
      reg.send("#{name}=", 'blah')
      reg.save
    end
  end

  it "should geocode to real values" do
    # accesses google. might temporarily fail
    reg.update_attributes(city: 'Berlin', country: 'DE')
    reg.lat.should be_within(0.5).of(52.52)
    reg.lng.should be_within(0.5).of(13.40)
  end
end