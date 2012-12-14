namespace :site do
  desc "Dump site defaults to yml"
  task dump: :environment do
    SiteDefault.dump("./config/site_defaults.yml")
  end

  desc "Load site defaults from yml"
  task load: :environment do
    SiteDefault.load("./config/site_defaults.yml")
  end
end