require 'spec_helper'

describe Team do
  context "scopes" do
    let(:future) { create(:team, date: Date.tomorrow) }
    let(:past) { create(:team, date: Date.yesterday) }

    before do
      future; past
    end

    it "finds upcoming teams" do
      expect(Team.upcoming).to eq([future])
    end

    it "finds previous teams" do
      expect(Team.previous).to eq([past])
    end

    it "orders date ascending" do
      expect(Team.by_date).to eq([past, future])
    end

    it "orders date descending" do
      expect(Team.by_date_desc).to eq([future, past])
    end
  end
end
