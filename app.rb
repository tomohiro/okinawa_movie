require 'rss'
require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  @title = '沖縄県映画上映時間一覧'
  @body  = '<ul>'

  RSS::Parser.parse('feed.xml').items.each do |movie|
    @body << "<li><a href='#{movie.link}'>#{movie.title}</a></li>"
    @body << "<li>#{movie.description}</li>"
  end

  @body << '</ul>'

  haml :index
end

get '/feed.xml' do
  open('feed.xml').read
end
