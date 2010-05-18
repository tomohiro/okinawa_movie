require 'rss'
require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  @title = '沖縄県映画上映時間一覧'
  @titles = ''
  @times  = ''
  index = 0

  items = RSS::Parser.parse('public/feed.xml').items

  items.each do |movie|
    @titles << "<li><a href='##{index}'>#{movie.title}</a></li>\n"
    @times << "<ul id='#{index}' title='#{movie.title}'><li>#{movie.description}</li></ul>\n"
    index += 1
  end


  haml :index
end
