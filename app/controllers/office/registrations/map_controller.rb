class Office::Registrations::MapController < Office::RegistrationsController

  # copied from http://google-maps-icons.googlecode.com/files/XXX.png so we can use https
  PARKANDRIDE_PICTURE = { picture: '/images/parkandride.png', width: 32, height: 37 }
  SITE_PICTURE = { picture: '/images/moderntower.png', width: 32, height: 37 }
  CAR_PICTURE = { picture: '/images/car.png', width: 32, height: 37 }

  TEAM_PICTURE = { picture: '/images/team.png', width: 19, height: 34 }
  FACILITATOR_PICTURE = { picture: '/images/facilitator.png', width: 19, height: 34 }
  PARTICIPANT_PICTURE = { picture: '/images/participant.png', width: 19, height: 34 }

  ROLE_TO_PICTURE = {Registration::TEAM => TEAM_PICTURE,
                     Registration::FACILITATOR => FACILITATOR_PICTURE,
                     Registration::PARTICIPANT => PARTICIPANT_PICTURE
  }

  def index
    params[:search] ||= {}
    @search = registrations.search(params[:search])

    @json = @search.all.to_gmaps4rails do |reg, marker|
      marker.infowindow render_to_string(:partial => '/office/shared/map_info',
                                         :locals => { angels: angels_at(reg.lat, reg.lng) })
      marker.picture(registration_picture(reg))
      marker.title reg.full_name
    end
  end

  private

  def registration_picture(registration)
    case registration.lift
      when Registration::REQUESTED
        PARKANDRIDE_PICTURE
      when Registration::OFFERED
        CAR_PICTURE
      else
        ROLE_TO_PICTURE[registration.role]
    end
  end

  def angels_at(lat, lng)
    event.angels.located_at(lat, lng)
  end
end
