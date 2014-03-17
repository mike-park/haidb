require 'spec_helper'

describe RosterPolicy do
  subject { RosterPolicy.new(user, roster) }
  let(:roster) { Roster.new(double('event')) }
  let(:angel) { create(:angel) }

  before do
    roster.stub(angels: [angel])
  end

  context "angel in roster" do
    let(:user) { build(:user, angel: angel) }
    it { should permit_action(:show) }
  end

  context "without an angel" do
    let(:user) { build(:user, angel: nil) }
    it { should_not permit_action(:show) }
  end

  context "with a different angel" do
    let(:user) { build(:user, angel: build(:angel)) }
    it { should_not permit_action(:show) }
  end
end
