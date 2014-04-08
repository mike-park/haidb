require 'spec_helper'

describe Csvable do
  let(:reg) { Registration.new(first_name: 'Mike', last_name: 'Park',
                               address: 'Street Address', postal_code: 'plz', city: 'Berlin', country: 'DE',
                               home_phone: '123', mobile_phone: '456', work_phone: '789',
                               email: 'name@example.com',
                               payment_method: 'Cash', bank_account_name: 'M Park', iban: 'iban', bic: 'bic',
                               registration_code: 'abc',
                               cost: 100, paid: 20, owed: 80,
                               notes: "A long\nmessage\nhere") }
  let(:csv) do
    <<EOF
"Role","Full name","Email","Gender","Address","Postal code","City","Country","Home phone","Mobile phone","Work phone","Payment method","Bank account name","Iban","Bic","Registration code","Cost","Paid","Owed","Status","Completed","Notes"
"Participant","Mike Park","name@example.com","","Street Address","plz","Berlin","DE","123","456","789","Cash","M Park","iban","bic","abc","100.0","20.0","80.0","pending","false","A long\nmessage\nhere"
EOF
  end
  let(:csv_fields) { [:role, :full_name, :email, :gender,
                      :address, :postal_code, :city, :country,
                      :home_phone, :mobile_phone, :work_phone,
                      :payment_method, :bank_account_name, :iban, :bic, :registration_code,
                      :cost, :paid, :owed,
                      :status, :completed,
                      :notes] }

  it "should convert array into csv" do
    Registration.to_csv([reg], csv_fields).should == csv
  end
end
