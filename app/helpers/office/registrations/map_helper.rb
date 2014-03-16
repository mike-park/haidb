module Office::Registrations::MapHelper

  def options_for_map_countries(form)
    country_codes = registrations.map(&:country).compact.uniq
    countries = Carmen::countries.select do |pair| name, code = pair
      country_codes.include?(code)
    end
    [['Filter by country', '']].concat(countries)
  end

  def options_for_map_lift(form)
    [['Filter by lift', ''],
     ['Offered & Requested', 'e'],
     ['Offered only', Registration::OFFERED],
     ['Requested only', Registration::REQUESTED]
    ]
  end
  
  def options_for_map_role(form)
    [['Filter by role', '']].concat(Registration::ROLES)
  end
end
