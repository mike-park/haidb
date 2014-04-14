Tabulous.setup do

  tabs(:office) do

    office_dashboards_tab do
      text { 'Dashboard' }
      link_path { office_root_path }
      visible_when { true }
      enabled_when { true }
      active_when { in_action('any').of_controller('office/dashboards') }
    end

    office_angels_tab do
      text { 'Angels' }
      link_path { office_angels_path }
      visible_when { true }
      enabled_when { true }
      active_when { %w{angels similar_angels angel_registrations}.each {|n| in_action('any').of_controller("office/#{n}")} }
    end

    office_teams_tab do
      text { 'Teams' }
      link_path { office_teams_path }
      visible_when { true }
      enabled_when { true }
      active_when { a_subtab_is_active }
    end

    future_office_teams_subtab do
      text { 'Upcoming' }
      link_path { office_teams_path }
      visible_when { true }
      enabled_when { true }
      active_when { %w{teams members}.each {|n| in_action('any').of_controller("office/#{n}")} }
    end

    past_office_teams_subtab do
      text { 'Past' }
      link_path { past_office_teams_path }
      visible_when { true }
      enabled_when { true }
      active_when { false }
    end

    office_memberships_tab do
      text { 'Memberships' }
      link_path { office_memberships_path }
      visible_when { true }
      enabled_when { true }
      active_when { in_action('any').of_controller('office/memberships') }
    end

    office_events_tab do
      text { 'Events' }
      link_path { office_events_path }
      visible_when { true }
      enabled_when { true }
      active_when do
        %w{events event_reports registrations registrations/completed registrations/checked_in registrations/map payments}.each do |n|
          in_action('any').of_controller("office/#{n}")
        end
      end
    end

    office_public_signups_tab do
      text { 'Public Signups' }
      link_path { office_public_signups_path }
      visible_when { true }
      enabled_when { true }
      active_when { in_action('any').of_controller('office/public_signups') }
    end

    office_site_defaults_tab do
      text { 'Site Defaults' }
      link_path { office_site_defaults_path }
      visible_when { true }
      enabled_when { true }
      active_when { %w{site_defaults site_defaults/email_names}.each {|n| in_action('any').of_controller("office/#{n}")} }
    end
  end

  tabs(:users) do
    users_dashboards_tab do
      text { 'Home' }
      link_path { users_root_path }
      visible_when { true }
      enabled_when { true }
      active_when { in_action('any').of_controller('users/dashboards') }
    end

    users_registrations_tab do
      text { 'Termine' }
      link_path { users_registrations_path }
      visible_when { current_user.registrations.any? }
      enabled_when { true }
      active_when { %w{registrations rosters}.each {|n| in_action('any').of_controller("users/#{n}")} }
    end

    users_teams_tab do
      text { 'Team' }
      link_path { users_teams_path }
      visible_when { current_user.active_membership? }
      enabled_when { true }
      active_when { %w{members teams}.each {|n| in_action('any').of_controller("users/#{n}")} }
    end

    users_angels_tab do
      text { 'Profil' }
      link_path { edit_users_angel_path }
      visible_when { true }
      enabled_when { true }
      active_when do
        in_actions('edit', 'update', 'show').of_controller("users/angels")
        in_actions('edit', 'update').of_controller("users/devise/registrations")
      end
    end

  end

  customize do

    # which class to use to generate HTML
    # :default, :html5, :bootstrap, or :bootstrap_pill
    # or create your own renderer class and reference it here
    renderer :bootstrap_pill_stacked

    # whether to allow the active tab to be clicked
    # defaults to true
    # active_tab_clickable true

    # what to do when there is no active tab for the current controller action
    # :render -- draw the tabset, even though no tab is active
    # :do_not_render -- do not draw the tabset
    # :raise_error -- raise an error
    # defaults to :do_not_render
    when_action_has_no_tab :render

    # whether to always add the HTML markup for subtabs, even if empty
    # defaults to false
    # render_subtabs_when_empty false

  end

  # The following will insert some CSS straight into your HTML so that you
  # can quickly prototype an app with halfway-decent looking tabs.
  #
  # This scaffolding should be turned off and replaced by your own custom
  # CSS before using tabulous in production.
  # use_css_scaffolding do
  #   background_color '#ccc'
  #   text_color '#444'
  #   active_tab_color '#fff'
  #   hover_tab_color '#ddd'
  #   inactive_tab_color '#aaa'
  #   inactive_text_color '#888'
  # end

end
