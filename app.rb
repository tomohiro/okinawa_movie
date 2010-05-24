require 'rss'
require 'rubygems'
require 'sinatra'
require 'haml'


get '/' do
  @movies = ''
  @times  = ''
  @google = google

  index = 0
  movies do |movie|
    if movie.description.nil?
      @movies << "<li class='group'>#{movie.title}</li>"
    else
      @movies << "<li><a href='##{index}'>#{movie.title}</a></li>\n"
      @times  << "<ul id='#{index}' title='#{movie.title}'><li>#{movie.description}</li></ul>\n"
    end
    index += 1
  end
  set :haml, {:format => :html5}
  haml :index
end

get '/m' do
  @movies = ''
  @google = google

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

def google
<<-GOOGLE
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-13275958-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
GOOGLE
end
