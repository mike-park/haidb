require 'spec_helper'

describe Roster do
  context "emails" do
    let(:email) { 'user@example.com' }
    let(:roster) { Roster.new(double('event')) }

    before do
      roster.stub(:emails).and_return([email])
    end

    it "verifies email is present" do
      expect(roster.has_email?(email)).to be_true
    end

    it "verifies another email is not present" do
      expect(roster.has_email?('not_there')).to be_false
    end
  end
end