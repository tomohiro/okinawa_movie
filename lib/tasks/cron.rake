require 'lib/cron/okinawa_movies.rb'

desc 'Heroku Cron Tasks'
task :cron => :environment do
  if Time.now.hour == 1
    OkinawaMovies.migrate
  end
end
