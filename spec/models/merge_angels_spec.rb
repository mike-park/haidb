require 'spec_helper'

describe MergeAngels do
  let(:a) { FactoryGirl.create(:angel, lang: 'en', gender: 'Male', email: 'a-email',
                               last_name: 'a-lastname', first_name: 'a-firstname')}
  let(:b) { FactoryGirl.create(:angel, lang: 'de', gender: 'Female', email: 'b-email',
                               last_name: 'b-lastname', first_name: 'b-firstname')}
  let(:event1) { FactoryGirl.create(:event1)}
  let(:event2) { FactoryGirl.create(:event2)}
  let(:reg1) { FactoryGirl.create(:registration, angel: a, event: event1)}
  let(:reg2) { FactoryGirl.create(:registration, angel: b, event: event2)}
  subject { MergeAngels.new([a.id, b.id]) }

  before do
    a
    reg1
    b
    reg2
  end

  it "should have records before merge" do
    expect(Angel.count).to eql(2)
    expect(Registration.count).to eql(2)
  end

  it "should merge b attributes into a" do
    result = subject.invoke
    expect(result).to be_true
    expect(Angel.count).to eql(1)
    angel = Angel.first
    expect(angel.id).to eql(a.id)
    expect(angel.lang).to eql('de')
    expect(angel.gender).to eql('Female')
    expect(angel.email).to eql('b-email')
    expect(angel.last_name).to eql('b-lastname')
    expect(angel.first_name).to eql('b-firstname')
  end

  it "should transfer b regs to a" do
    subject.invoke
    angel = Angel.first
    expect(angel.registrations.count).to eql(2)
    expect(angel.registration_ids).to eql([reg1.id, reg2.id])
  end

end