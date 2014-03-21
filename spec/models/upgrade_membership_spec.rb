require 'spec_helper'

describe UpgradeMembership do

  def angel_with(count)
    angel = create(:angel)
    create_list(:full_registration, count, role: Registration::TEAM, angel: angel) if count
    angel
  end

  def membership_with(status, count)
    create(:membership, status: status, angel: angel_with(count))
  end

  let(:membership) { membership_with(status, on_team) }

  before do
    @changed = membership.recalc_status
  end

  [
      # from          on team          to
      [Membership::AWS, 1, Membership::PRELIMINARY],
      [Membership::NOVICE, 4, Membership::EXPERIENCED]
  ].each do |status, count, next_status|
    context "#{status}" do
      let(:status) { status }

      context "changes when on team" do
        let(:on_team) { count }
        it { expect(membership.status).to eq(next_status) }
        it { expect(@changed).to be_true }
      end

      context "does not change when not on team enough" do
        let(:on_team) { count - 1 }
        it { expect(membership.status).to eq(status) }
        it { expect(@changed).to be_false }
      end
    end
  end
end