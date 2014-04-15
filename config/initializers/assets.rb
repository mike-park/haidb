Rails.application.configure do

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w(public_signup.js de.css uk.css)

  # gmaps4rails additions
  config.assets.precompile += %w(gmaps4rails/gmaps4rails.base.js gmaps4rails/gmaps4rails.googlemaps.js)
end
