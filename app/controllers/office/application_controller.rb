class Office::ApplicationController < ApplicationController
  before_filter :authenticate_staff!
  before_filter :build_main_navigation
  
  layout 'office/application'
  
  private

  def build_main_navigation
    tabs = [{ :display => 'Dashboard',
              :link => office_dashboards_path,
              :paths => ['/office',['/office/dashboards*'],
                         '/en/office',['/en/office/dashboards*'],
                         '/de/office',['/de/office/dashboards*']
                        ] },
            { :display => 'Angels',
              :link => office_angels_path,
              :paths => [['/office/angels*'],
                         ['/en/office/angels*'],
                         ['/de/office/angels*']
                        ] },
            { :display => 'Events',
              :link => office_events_path,
              :paths => [['/office/events*'],
                         ['/en/office/events*'],
                         ['/de/office/events*']
                        ] },
            { :display => 'Public Signups',
              :link => office_public_signups_path,
              :paths => [['/office/public_signups*'],
                         ['/en/office/public_signups*'],
                         ['/de/office/public_signups*']
                        ] }
            ]
    @main_navigation = Mmmenu.new(:request => request) do |m|
      tabs.each do |tab|
        m.add tab[:display], tab[:link], :paths => tab[:paths]
      end
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
    
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # controller & helper routines to handle angels, events & registrations
  
  def find_event_or_angel
    unless parent
      redirect_to(office_events_url, :alert => 'You must select an event first')
    end
  end

  def find_angel
    unless parent
      redirect_to(office_angels_url, :alert => 'You must select an angel first.')
    end
  end

  def find_event
    unless parent
      redirect_to(office_events_url, :alert => 'You must select an event first.')
    end
  end

  def parent
    raise "Parent must be redefined by subclass"
  end
  helper_method :parent
  hide_action :parent
  
  def events
    @events
  end
  helper_method :events
  hide_action :events
  
  def event
    @event ||= Event.find_by_id(params[:event_id] || params[:id])
  end
  helper_method :event
  hide_action :event
  
  def angels
    @angels
  end
  helper_method :angels
  hide_action :angels

  def angel
    @angel ||= Angel.find_by_id(params[:angel_id] || params[:id])
  end
  helper_method :angel
  hide_action :angel
  
  def registrations
    @registrations ||= parent.registrations.ok.by_first_name
  end
  helper_method :registrations
  hide_action :registrations
  
  # return current registration, its ok to return nil
  def registration
    @registration ||= registrations.find_by_id(params[:id])
  end
  helper_method :registration
  hide_action :registration
  
  
end
