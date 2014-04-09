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

  context "assign_to" do
    let(:angel) { create(:full_angel) }
    let(:event) { create(:event) }
    let(:team) { create(:team, event: event) }
    let(:membership) { create(:membership, team_cost: 99) }
    let(:member) { create(:member, angel: angel, team: team, membership: membership) }
    let(:registration) { member.assign_to(event) }

    it "adds registration to event" do
      expect(registration).to be_valid
      expect(event.registrations).to include(registration)
    end

    it "builds from angel" do
      Registration.should_receive(:new_from).with(angel).and_return(Registration.new)
      registration
    end

    context "registration" do
      subject { registration }

      its(:role) { should eq(Registration::TEAM) }
      its(:status) { should eq(Registration::APPROVED) }
      its(:cost) { should eq(member.team_cost) }
    end

    context "angel already registered" do
      before do
        event.registrations.create!((attributes_for :registration).merge(angel_id: angel.id))
      end

      it "should have invalid registration" do
        expect(registration).to_not be_valid
        expect(registration.errors.messages[:event_id]).to be
      end
    end
  end
end