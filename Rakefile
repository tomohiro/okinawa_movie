$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'task/okinawa_movies'

desc 'Update Okinawa movie showtimes'
task :update do
  puts 'Update movie showtime information.'
  puts "    ---> start #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}"
  okinawa_movies = OkinawaMovies.new
  okinawa_movies.update
  puts "    ---> end #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}"
end
