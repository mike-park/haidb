module Office::MembersHelper

  def options_for_member_role(form)
    choices = [['Member', '']] + Member::ROLES.map {|r| [r, r]}
    {:as => :radio_buttons, :collection => choices}
  end

end
