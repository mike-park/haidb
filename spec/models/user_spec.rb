require 'spec_helper'

describe User do
  context "devise" do
    let(:user) { build(:user) }
    let(:mailer) { double('mailer', deliver: true) }

    it "sends a confirmation email when created" do
      Devise.mailer.should_receive(:confirmation_instructions).and_return(mailer)
      user.save!
    end

    it "sends a confirmation email when email updated" do
      user.save!
      Devise.mailer.should_receive(:confirmation_instructions).and_return(mailer)
      user.update_attribute(:email, "something@new.com")
      expect(user.email).to_not eql("something@new.com")
    end

    it "doesnt attach angel on creation" do
      user.should_not_receive(:attach_angel)
      user.save!
    end

    it "attaches angel when confirmed" do
      user.save!
      user.should_receive(:attach_angel)
      user.confirm!
    end
  end
end
