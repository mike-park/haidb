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

end
