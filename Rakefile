$: << './'

require 'cron/okinawa_movies'

desc 'Okinawa movie showtime update.'
task :cron do
  puts 'Okinawa movie showtime update.'
  ENV['TZ'] = 'Asia/Tokyo'

  puts "Running migrate start #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
  okinawa_movies = OkinawaMovies.new
  okinawa_movies.migrate
  okinawa_movies.rss
  puts "Running migrate end #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
end
