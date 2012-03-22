module Office::Registrations::CompletedHelper
  def completed_toggle(registration)
    form_tag({ :action => "update",
               :controller => "office/registrations/completed",
               :event_id => event,
               :id => registration },
             { :method => :put }) do
      submit_tag('Toggle', class: 'btn')
    end
  end
end
