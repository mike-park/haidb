module ControllerMacros
  def login_staff
    before(:each) do
      @request.env["devise.mapping"] = :staff
      sign_in FactoryGirl.create(:staff)
    end
  end
end
