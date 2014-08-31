require 'spec_helper'

describe Membership do

  context "validations" do
    it 'should not allow two active memberships' do
      I18n.locale = :en
      membership = create(:membership)
      membership = build(:membership, angel: membership.angel, status: Membership::STATUSES.first)
      expect { membership.save! }.to raise_exception(ActiveRecord::RecordInvalid, /Already has an active membership/)
    end

    it 'should allow memberships with 1 active' do
      membership = create(:membership, retired_on: Date.current)
      membership = build(:membership, angel: membership.angel, status: Membership::STATUSES.first)
      expect(membership.save!).to be_true
    end
  end

  context "scopes" do
    before do
      create(:membership, active_on: Date.yesterday, retired_on: Date.current)
      create(:membership, active_on: Date.today, retired_on: nil)
    end

    it { expect(Membership.active.count).to eq(1) }
    it { expect(Membership.retired.count).to eq(1) }
    it { expect(Membership.by_active_on_desc.map(&:active_on)).to eq([Date.today, Date.yesterday]) }
  end

  context "move_to" do
    let(:angel) { build(:angel) }
    let(:memberships) { create_list(:membership, 3) }

    before do
      Membership.move_to(angel, memberships)
    end

    it "should assign all memberships to angel" do
      expect(angel.memberships.count).to eq(3)
    end

    context "all become retired" do
      let(:memberships) do
        [
            create(:membership, active_on: Date.current - 1.week, retired_on: nil),
            create(:membership, active_on: Date.yesterday, retired_on: Date.current),
        ]
      end

      it { expect(Membership.all.map(&:retired?)).to eq([true, true]) }
    end

    context "most recent entry is not retired" do
      let(:memberships) do
        [
            create(:membership, active_on: Date.current - 1.week, retired_on: nil),
            create(:membership, active_on: Date.tomorrow, retired_on: nil),
            create(:membership, active_on: Date.yesterday, retired_on: nil)
        ]
      end

      it { expect(Membership.retired.count).to eq(2) }
      it { expect(angel.active_membership.active_on).to eq(Date.tomorrow) }
    end
  end


  context "upgrade_membership" do
    it "should upgrade all active memberships" do
      m = double('membership')
      Membership.stub(:active).and_return([m, m])
      m.should_receive(:upgrade_membership).exactly(2)
      Membership.upgrade_memberships
    end

    it "should not change provisional status" do
      membership = build(:membership, status: Membership::PROVISIONAL)
      expect { membership.upgrade_membership }.to_not change(membership, :status)
    end

    it "should upgrade novice to experienced after 4 events" do
      membership = build(:membership, status: Membership::NOVICE)
      membership.stub(:hai_workshops_team_registrations).and_return(build_list(:registration, 4))
      expect { membership.upgrade_membership }.to_not change(membership, :status)
      membership.stub(:hai_workshops_team_registrations).and_return(build_list(:registration, 5))
      expect { membership.upgrade_membership }.to change(membership, :status)
      expect(membership.status).to eq(Membership::EXPERIENCED)
    end
  end
end
