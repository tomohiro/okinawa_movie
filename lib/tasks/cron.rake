#require 'cron/okinawa_movies.rb'

task :cron => :environment do
  OkinawaMovies.migrate
end
