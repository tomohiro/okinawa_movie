require 'rss'

class Movies
  def initialize
    @movies = RSS::Parser.parse('public/feed.xml').items
  end

  def all
    @movies
  end

  def each
    @movies.each { |m| yield m }
  end

  def by_screen(screen)
    @movies.find_all { |item| item.source.to_s.include? screen }
  end

  def by_title(title)
    @movies.find { |movie| title == movie.title }
  end
end
