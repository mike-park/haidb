module Office::MembershipsHelper
  def options_for_membership_status(form)
    { :as => :radio, :collection => Membership::STATUSES }
  end

  def registration_counts_by_milestones(registrations, milestones)
    dates = registrations.map(&:start_date)
    today = Date.current
    milestones = milestones.map {|m| today - m }
    milestones.map do |milestone|
      found = dates.find_all { |d| d >= milestone }
      dates -= found
      td_colorize(found.length)
    end.join("").html_safe
  end

  def td_colorize(count)
    color = count > 0 ? 'dot-green' : 'dot-red'
    content_tag(:td, count, class: "center #{color}")
  end
end