# rails-assets-angular-strap references angular-strap/angular-strap.tpl.min which is interpreted as a .tpl
# file by sprockets. Ensure .tpl has the correct mime-type
Rack::Mime::MIME_TYPES.merge!(".tpl" => "application/javascript")