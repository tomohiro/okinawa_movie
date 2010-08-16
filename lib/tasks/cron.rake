require 'lib/cron/okinawa_movies.rb'

desc 'Heroku Cron Tasks'
task :cron => :environment do
  OkinawaMovies.migrate
end
