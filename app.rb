require 'rubygems'
require 'sinatra'
require 'haml'

require 'model/movie'

set :haml, {:format => :html5}

get '/' do
  @startheaters = Movie.startheaters
  @sakurazaka   = Movie.sakurazaka

  haml :index
end

get '/showtime/:id' do
  @title = Movie[params[:id]].title
  @poster = Movie[params[:id]].poster
  @movie = Movie.showtime(params[:id])

  haml :showtime
end

get '/author' do
  haml :author
end

get '/m' do
  @movies = Movie.group(:title)

  set :haml, {:format => :html4}
  haml :mobile
end

get '/cron' do
  require 'cron/okinawa_movies.rb'
  OkinawaMovies.migrate
end
