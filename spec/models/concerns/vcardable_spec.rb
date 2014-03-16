require 'spec_helper'

describe Vcardable do
  let(:reg) { Registration.new(first_name: 'Mike', last_name: 'Park',
                               address: 'Street Address', postal_code: 'plz', city: 'Berlin', country: 'DE',
                               home_phone: '123', mobile_phone: '456', work_phone: '789',
                               email: 'name@example.com',
                               notes: "A long\nmessage\nhere") }
  let(:vcard) do
    <<EOF
BEGIN:VCARD
VERSION:3.0
N:Park;Mike;;;
FN:Mike Park
ADR;TYPE=home,pref:;;Street Address;Berlin;;plz;DE
EMAIL;TYPE=home:name@example.com
TEL;TYPE=home:123
TEL;TYPE=mobile:456
TEL;TYPE=work:789
NOTE:A long\\nmessage\\nhere
END:VCARD
EOF
  end

  it "should generate a valid vcard" do
    reg.to_vcard.should == vcard
  end

  it "should convert array into vcards" do
    Registration.to_vcard([reg, reg]).should == "#{vcard}#{vcard}"
  end
end