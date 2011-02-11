class Office::Registrations::MapController < Office::RegistrationsController
  def index
    params[:search] ||= {}
    @search = registrations.search(params[:search])

    @map = Cartographer::Gmap.new( 'map', :debug => true )
    @map.zoom = :bound
    
    site = Cartographer::Gicon.new(:name => 'site',
                                 :image_url => "http://google-maps-icons.googlecode.com/files/moderntower.png",
                                 :width => 32,
                                 :height => 37)
    pr = Cartographer::Gicon.new(:name => 'pr',
                                 :image_url => "http://google-maps-icons.googlecode.com/files/parkandride.png",
                                 :width => 32,
                                 :height => 37)
    car = Cartographer::Gicon.new(:name => 'car',
                                 :image_url => "http://google-maps-icons.googlecode.com/files/car.png",
                                 :width => 32,
                                 :height => 37)
    team = Cartographer::Gicon.new(:name => 'team',
                                   :image_url => "/images/team.png",
                                   :width => 19,
                                   :height => 34)
    facilitator = Cartographer::Gicon.new(:name => 'facilitator',
                                   :image_url => "/images/facilitator.png",
                                   :width => 19,
                                   :height => 34)
    participant = Cartographer::Gicon.new(:name => 'participant',
                                   :image_url => "/images/participant.png",
                                   :width => 19,
                                   :height => 34)
    role_to_icon = {
      Registration::TEAM => team,
      Registration::FACILITATOR => facilitator,
      Registration::PARTICIPANT => participant,
    }
    
    icon = Cartographer::Gicon.new
    @map.icons.concat([site, icon, pr, car, team, facilitator, participant])

    @search.all.select {|r| r.angel.geocoded? }.each do |r|
      angel = r.angel
      choosen_icon = case r.lift
                     when Registration::REQUESTED
                       pr
                     when Registration::OFFERED
                       car
                     else
                       role_to_icon[r.role] || icon
                     end
      @map.markers << Cartographer::Gmarker.new(:name => "id#{angel.id}",
           :marker_type => "Person",
           :position => [angel.lat,angel.lng],
           :info_window_url => office_angel_url(angel, :format => :map),
           :icon => choosen_icon)
    end
    if @map.markers.any? && Site.de?
      @map.markers << Cartographer::Gmarker.new(:name => 'site',
           :marker_type => "Site",
           :position => [52.066864,7.211409],
           :icon => site)
    end

  end
end
