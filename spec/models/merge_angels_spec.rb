require 'spec_helper'

describe MergeAngels do
  let(:create_dummies) { [:angel, :registration, :membership, :user].map { |n| create(n) } }

  before do
    create_dummies
    MergeAngels.new(angels).invoke
  end

  context "counts" do
    let(:angels) { create_pair(:angel) }

    it { expect(Angel.count).to eq(3) }

    [Registration, Membership, User].each do |model|
      plurals = model.to_s.downcase.pluralize
      symbol = model.to_s.downcase.to_sym

      context "has_many #{plurals}" do
        let(:record1) { create(symbol, angel: create(:angel)) }
        let(:record2) { create(symbol, angel: create(:angel)) }
        let(:angels) { [record1.angel, record2.angel] }

        it { expect(angels.first).to_not eq(angels.second) }
        it { expect(model.count).to eq(3) }
        it { expect(record1.angel.send(plurals).count).to eq(2) }
      end
    end
  end

  context "attributes" do
    def all_attributes(value)
      fields = Angel.new.attributes.keys - MergeAngels::EXCLUDE_FIELDS
      fields.inject({}) do |memo, field|
        memo[field] = value
        memo
      end
    end

    let(:angel0) { create(:angel, all_attributes('0').merge("gender" => Registration::MALE)) }
    let(:angel1) { create(:angel, all_attributes('1').merge("gender" => Registration::FEMALE)) }
    let(:angel2) { create(:angel, all_attributes('2').merge("gender" => Registration::MALE)) }
    let(:angel3) { create(:angel, all_attributes('3').merge("gender" => Registration::FEMALE)) }
    let(:angels) { [angel1, angel3, angel2] }

    it { expect(angel0.notes).to eq('0') }
    it { expect(angel1.notes).to eq('2') }

    it "copies attributes from angel2 to angel1" do
      expect(angel1.attributes.except(*MergeAngels::EXCLUDE_FIELDS)).to eq(angel2.attributes.except(*MergeAngels::EXCLUDE_FIELDS))
    end
  end
end