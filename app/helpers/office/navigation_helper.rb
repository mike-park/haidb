module Office::NavigationHelper

  def build_public_signup_breadcrumbs(public_signup)
    BreadCrumbBuilder.new(public_signup) do |b|
      b.add :index, 'Pending Public Signups', office_public_signups_path
      b.add :approved, 'Approved Public Signups', approved_office_public_signups_path
      b.add :show, public_signup, [:office, public_signup]
      b.filter :name, do |name|
        name = :approved if name == :index &&
          public_signup &&
          public_signup.approved?
        name
      end
    end
  end

  def public_signup_breadcrumbs
    build_breadcrumbs(build_public_signup_breadcrumbs(public_signup))
  end
      
  def build_angel_breadcrumbs(angel)
    BreadCrumbBuilder.new(angel) do |b|
      b.add :index, 'Angels', office_angels_path
      b.add :show, angel, [:office, angel]
    end
  end

  def angel_breadcrumbs
    build_breadcrumbs(build_angel_breadcrumbs(angel))
  end
      
  def build_event_breadcrumbs(event)
    BreadCrumbBuilder.new(event) do |b|
      b.add :index, 'Future Events', office_events_path
      b.add :past, 'Past Events', past_office_events_path
      b.add :show, event, [:office, event]
      b.filter :name, do |name|
        name = :past if name == :index &&
          event &&
          event.start_date &&
          event.start_date < Date.current
        name
      end
    end
  end

  def event_breadcrumbs
    build_breadcrumbs(build_event_breadcrumbs(event))
  end
      
  def build_registration_breadcrumbs(registration)
    BreadCrumbBuilder.new(registration) do |b|
      b.add :index, lambda { ['Registrations', [:office, parent, :registrations]] }
      b.add :show, lambda { [registration, [:office, parent, registration]] }
    end
  end

  def registration_breadcrumbs
    crumbs =  build_breadcrumbs(build_event_breadcrumbs(event), :show)
    crumbs << build_breadcrumbs(build_registration_breadcrumbs(registration))
    crumbs
  end
      
  def registration_navigation
    tabs = [["#{parent.display_name} Registrations", :index]]
    if parent.kind_of?(Event)
      tabs << ['Checklist', :checklist]
      tabs << ['Roster', :roster]
    end
    tabs
  end

  def display_name_or_id(something)
    if something.respond_to?(:display_name)
      result = something.display_name 
      result = "##{something.id}" if result.blank?
    else
      result = something.to_s
    end
    result
  end

  def status_menu
  end

  def user_navigation
    content_tag(:li, link_to('Logout', destroy_staff_session_path))
  end

  def main_navigation
    build_mmmenu(@main_navigation)
  end

  # [['Edit event', :edit, event], ...]
  def block_navigation(routes = nil)
    routes = [routes] unless routes.kind_of?(Array)
    secondary_navigation do |nav|
      routes.compact.each do |display, action, object|
        if action.nil?
          active = true
          path = url_for
        else
          active = controller.action_name == action.to_s
          options = { :action => action }
          options.merge!({ :id => object }) unless object.nil?
          path = url_for(options)
        end
        display = display.to_s.capitalize if display.kind_of?(Symbol)
        nav.item display, path, :active => active
      end
      yield nav if block_given?
    end
  end

  # [['Future Events', href], ['Level 1: 12.12.2010', href], ...]
  def block_footer(*routes)
    breadcrumbs do |b|
      routes.flatten.each_slice(2) do |display, path|
        b.item display, path
      end
      yield b if block_given?
    end
  end

  # this is still a hack.  i don't know how to add url_for into BreadCrumbBuilder
  # class. so hence this routine
  def build_breadcrumbs(items, action = controller.action_name.to_sym)
    crumbs = []
    if !items.object.nil?
      crumbs << [items.action_display(:index), url_for(items.action_path(:index))]
    end
    crumbs << [items.action_display(action), url_for(items.action_path(action))]
    crumbs
  end

  class BreadCrumbBuilder
    attr_reader :object
    
    def initialize(object = nil)
      @actions = {}
      @filter = {}
      @object = object
      yield self if block_given?
    end

    def filter(name, &block)
      @filter[name] = block
    end
    
    def standardize_name(name)
      name = name.to_sym
      name = :edit if name == :update
      name = :new if name == :create
      name = @filter[:name].call(name) if @filter[:name]
      name
    end

    def standardize_display(something)
      if something.respond_to?(:display_name)
        result = something.display_name 
        result = "##{something.id}" if result.blank?
      else
        result = something.to_s
      end
      result
    end
    
    def action_display(name)
      name = standardize_name(name)
      display, path = @actions[name]
      display = display.call.first if display.kind_of?(Proc)
      display = name.to_s.capitalize if display.blank?
      standardize_display(display)
    end

    def action_path(name)
      name = standardize_name(name)
      display, path = @actions[name]
      path = display.call.last if display.kind_of?(Proc)
      path ||= {:action => name}
      path
    end

    def add(action, display = nil, path = nil)
      @actions[action.to_sym] = [display, path]
    end
  end
end
