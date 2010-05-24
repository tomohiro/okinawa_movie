require 'ostruct'
require 'rubygems'
require 'sinatra'
require 'haml'
require 'movies'

set :haml, {:format => :html5}

get '/' do
  @movies = Movies.new
  @star_theaters = @movies.by_screen 'startheaters'
  @sakurazaka = @movies.by_screen 'google'

  haml :index
end

get '/schedule/:title' do
  movie = Movies.new.by_title params[:title]
  @title = movie.title

  @schedule_list = []
  movie.description.split('<br>').each do |info|
    info = info.split(' ')
    screen = info.shift

    info.each do |times|
      @schedule_list << OpenStruct.new({
        :screen => screen,
        :start  => times.split('～')[0],
        :end    => times.split('～')[1] || nil
      })
    end
  end

  haml :schedule
end

get '/m' do
  @movies = Movies.new

  set :haml, {:format => :html4}
  haml :mobile
end
