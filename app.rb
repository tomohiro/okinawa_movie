require 'rubygems'
require 'sinatra'
require 'haml'

require 'model/movie'

set :haml, { :format => :html5 }

get '/' do
  @startheaters = Movie.startheaters
  @sakurazaka   = Movie.sakurazaka

  haml :index
end

get '/showtime/:id' do |id|
  movie   = Movie[id]
  @title  = movie.title
  @poster = movie.poster
  @movie  = Movie.showtime id

  haml :showtime
end

get '/feed.xml' do
  open('tmp/feed.xml').read
end
