namespace :geocode do

  desc "Geocode all Angels without coordinates."
  task :all => :environment do
    puts "Processing #{Angel.not_geocoded.count} angels"
    Angel.not_geocoded.each do |obj|
      obj.save	# before_save will auto fetch coordinates
    end
    puts "#{Angel.not_geocoded.count} not geocoded."
  end

  desc "Geocode all Angels, including those already geocoded."
  task :update => :environment do
    puts "Processing #{Angel.count} angels"
    Angel.all.each do |obj|
      obj.save	# before_save will auto fetch coordinates
    end
    puts "#{Angel.not_geocoded.count} not geocoded."
  end

end
