module Office::Registrations::MapHelper

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
