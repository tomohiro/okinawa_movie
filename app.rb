require 'rss'
require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  @movies = ''
  @times  = ''

  index = 0
  movies do |movie|
    if movie.description.nil?
      @movies << "<li class='group'>#{movie.title}</li>\n"
    else
      @movies << "<li><a href='##{index}'>#{movie.title}</a></li>\n"
      @times  << "<ul id='#{index}' title='映画館別上映時間'>\n"
      @times  << "<li class='group'><a href='#{movie.link}' target='_blank' title='#{movie.title}'>#{movie.title}</a></li>\n"
      movie.description.split('<br>').each do |time|
        @times << "<li>#{time}</li>\n"
      end
      @times << "</ul>\n"
    end
    index += 1
  end

  set :haml, {:format => :html5}
  haml :index
end

get '/m' do
  @movies = ''

  movies do |movie|
    next if movie.description.nil?
    @movies << "<dt>#{movie.title}</dt>\n"
    @movies << "<dd>#{movie.description}</dd>\n"
  end

  haml :mobile
end

def movies
  RSS::Parser.parse('public/feed.xml').items.each { |m| yield m }
end
