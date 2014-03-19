require 'spec_helper'

describe Member do
  context "validations" do
    let(:member) { create(:member) }

    it "should have a valid factory" do
      expect(member).to be_valid
    end

    it "should require a valid gender" do
      member.gender = 'XX'
      expect(member).to_not be_valid
    end

    it "should only allow 1 member entry per team" do
      member2 = build(:member, angel: member.angel, team: member.team)
      expect(member2).to_not be_valid
      expect(member2.errors.messages).to eq(angel_id: ["Already signed up on this team"])
    end

    [:angel, :membership, :team, :full_name, :gender].each do |name|
      it "should require #{name}" do
        member.update_attributes(name => nil)
        expect(member).to_not be_valid
      end
    end
  end
end
