require 'spec_helper'

describe Membership do

  context "validations" do
    it 'should not allow two active memberships' do
      I18n.locale = :en
      membership = FactoryGirl.create(:membership)
      membership = FactoryGirl.build(:membership, angel: membership.angel, status: Membership::STATUSES.first)
      expect { membership.save! }.to raise_exception(ActiveRecord::RecordInvalid, /Already has an active membership/)
    end

    it 'should allow memberships with 1 active' do
      membership = FactoryGirl.create(:membership, retired_on: Date.current)
      membership = FactoryGirl.build(:membership, angel: membership.angel, status: Membership::STATUSES.first)
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

  context "self.recalc_status" do
    let(:membership1) { double("membership1", recalc_status: true) }
    let(:membership2) { double("membership2", recalc_status: false) }
    let(:memberships) { [membership1, membership2]}
    before do
      Membership.stub(:active).and_return(memberships)
    end
    it "should return changed memberships" do
      expect(Membership.recalc_status).to eq([membership1])
    end
  end
end
