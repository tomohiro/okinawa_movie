require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  @title = 'Fuck, World!'
  @body = open('movies.txt').read
  haml :index
end
