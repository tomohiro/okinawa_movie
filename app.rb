require 'ostruct'
require 'rubygems'
require 'sinatra'
require 'haml'
require 'showtime'

set :haml, {:format => :html5}

before do
  @showtime = ShowTime.new
end

get '/' do
  @star_theaters = @showtime.find_by_theater 'startheaters'
  @sakurazaka = @showtime.find_by_theater 'google'

  haml :index
end

get '/showtime/:title' do
  movie = @showtime.find_by_title(params[:title])
  @title = movie.title

  @showtimes = []
  movie.description.split('<br>').each do |info|
    info = info.split(' ')
    theater = info.shift

    info.each do |time|
      @showtimes << OpenStruct.new({
        :theater => theater,
        :start   => time.split([0XFF5E].pack('U'))[0],
        :end     => time.split([0XFF5E].pack('U'))[1]
      })
    end
  end

  haml :showtime
end

get '/author' do
  haml :author
end

get '/m' do
  @movies = @showtime.all

  set :haml, {:format => :html4}
  haml :mobile
end
