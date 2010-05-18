require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  @title = '沖縄県映画上映時間一覧'
  @body = open('movies.txt').read
  haml :index
end
