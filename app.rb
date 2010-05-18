require 'rss'
require 'rubygems'
require 'sinatra'
require 'haml'

require 'okinawa_movies'

set :haml, :format => :html5

get '/' do
  @title = '沖縄県映画上映時間一覧'
  @body  = '<ul>'

  rss = OkinawaMovies.rss
  rss.items.each do |movie|
    @body << "<li><a href='#{movie.link}'>#{movie.title}</a></li>"
    movie.description.each { |theater| @body << "<li>#{theater}</li>" }
  end

  @body << '</ul>'

  haml :index
end

get '/feed.xml' do
  OkinawaMovies.rss.to_s
end
