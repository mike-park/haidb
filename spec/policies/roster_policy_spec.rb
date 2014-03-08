require 'spec_helper'

describe RosterPolicy do
  subject { RosterPolicy.new(user, roster) }
  let(:roster) { Roster.new(double('event')) }

  before do
    roster.stub(emails: ['matched address'])
  end

  context "part of roster" do
    let(:user) { build(:user, email: 'matched address')}
    it { should permit_action(:show) }
  end

  context "not part of roster" do
    let(:user) { build(:user, email: 'not matched') }
    it { should_not permit_action(:show) }
  end
end
