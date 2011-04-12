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
                        ] },
            { :display => 'Site Defaults',
              :link => office_site_defaults_path,
              :paths => [['/office/site_defaults*'],
                         ['/en/office/site_defaults*'],
                         ['/de/office/site_defaults*']
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
  
  def event
    @event ||= Event.find_by_id(params[:event_id] || params[:id])
  end
  helper_method :event
  hide_action :event
  
  def angel
    @angel ||= Angel.find_by_id(params[:angel_id] || params[:id])
  end
  helper_method :angel
  hide_action :angel
  
  
  # return current registration, its ok to return nil
  def registration
    @registration ||= registrations.find_by_id(params[:id])
  end
  helper_method :registration
  hide_action :registration

  # wrap block call with language set
  def with_language(language = :en)
    locale = I18n.locale
    I18n.locale = language
    yield
    I18n.locale = locale
  end
  
  def angel_info_window_url(angel)
    map_info_office_angels_url(:lat => angel.lat, :lng => angel.lng)
  end
end
