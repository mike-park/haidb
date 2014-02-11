require 'spec_helper'

describe Membership do

  context "validations" do
    it 'should not allow two active memberships' do
      membership = FactoryGirl.create(:membership)
      membership = FactoryGirl.build(:membership, angel: membership.angel, status: Membership::STATUSES.first)
      expect { membership.save! }.to raise_exception(ActiveRecord::RecordInvalid, /Angel id has already been taken/)
    end

    it 'should allow memberships with 1 active' do
      membership = FactoryGirl.create(:membership, retired_on: Date.current)
      membership = FactoryGirl.build(:membership, angel: membership.angel, status: Membership::STATUSES.first)
      expect(membership.save!).to be_true
    end
  end
end
