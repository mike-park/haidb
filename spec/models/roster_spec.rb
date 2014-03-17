require 'spec_helper'

describe Roster do
  context "emails" do
    let(:angel) { create(:angel) }
    let(:registration) { create(:registration, angel: angel) }
    let(:roster) { Roster.new(registration.event) }

    it "verifies angel is present when registration is completed" do
      registration.update_attributes(approved: true, completed: true)
      expect(roster.has_angel?(angel)).to be_true
    end

    it "verifies angel is not present when registration is not completed" do
      registration.update_attributes(approved: false, completed: true)
      expect(roster.has_angel?(angel)).to_not be_true
      registration.update_attributes(approved: true, completed: false)
      expect(roster.has_angel?(angel)).to_not be_true
    end

    it "verifies another angel is not present" do
      expect(roster.has_angel?(create(:angel))).to be_false
    end
  end
end