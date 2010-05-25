require 'ostruct'
require 'rubygems'
require 'sinatra'
require 'haml'
require 'movie'

set :haml, {:format => :html5}

get '/' do
  movie = Movie.new
  @star_theaters = movie.find_by_screen 'startheaters'
  @sakurazaka = movie.find_by_screen 'google'

  haml :index
end

get '/schedule/:title' do
  movie = Movie.new.find_by_title params[:title]
  @title = movie.title

  @schedule_list = []
  movie.description.split('<br>').each do |info|
    info = info.split(' ')
    screen = info.shift

    info.each do |times|
      @schedule_list << OpenStruct.new({
        :screen => screen,
        :start  => times.split([0XFF5E].pack('U'))[0],
        :end    => times.split([0XFF5E].pack('U'))[1] || nil
      })
    end
  end

  haml :schedule
end

get '/author' do
  haml :author
end

get '/m' do
  @movies = Movie.new.all

  set :haml, {:format => :html4}
  haml :mobile
end
