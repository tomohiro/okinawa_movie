require 'cron/okinawa_movies'

desc 'Okinawa movie showtime update.'
task :migrate do
  puts "Running migrate start #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
  OkinawaMovies.migrate
  puts "Running migrate end #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
end
