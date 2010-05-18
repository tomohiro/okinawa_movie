require 'rss'
require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  @title = '沖縄県映画上映時間一覧'
  @titles = ''
  @times  = ''

  items = RSS::Parser.parse('public/feed.xml').items

  items.each do |movie|
    @titles << "<li><a href='##{movie.title}'>#{movie.title}</a></li>\n"
    @times << "<ul id='#{movie.title}' title='#{movie.title}'><li>#{movie.description}</li></ul>\n"
  end


  haml :index
end
