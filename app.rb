require 'rss'
require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  @movies = ''
  @times  = ''
  @google = google
  index = 0

  items = RSS::Parser.parse('public/feed.xml').items

  items.each do |movie|
    @movies << "<li><a href='##{index}'>#{movie.title}</a></li>\n"
    @times << "<ul id='#{index}' title='#{movie.title}'><li>#{movie.description}</li></ul>\n"
    index += 1
  end

  haml :index
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
