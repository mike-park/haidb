module Office::MembershipsHelper
  def options_for_membership_select(form)
    { :as => :select, :label => 'Angel', :collection => Membership.by_full_name, label_method: :full_name_with_context, value_method: :id }
  end

  def members_for_select(gender)
    [["Quick Add #{gender} Member", '']] + Membership.active.with_gender(gender).by_full_name.map do |membership|
      [membership.full_name_with_context, membership.id]
    end
  end

  def options_for_membership_status(form)
    { :as => :radio_buttons, :collection => Membership::STATUSES }
  end

  def options_for_membership_default_role(form)
    { :collection => Membership::ROLES }
  end

  def registration_counts_by_milestones(registrations, milestones)
    dates = registrations.map(&:start_date)
    today = Date.current
    milestones = milestones.map {|m| today - m }
    milestones.map do |milestone|
      found = dates.find_all { |d| d >= milestone }
      dates -= found
      td_colorize(found.length, 'center')
    end.join("").html_safe
  end
end