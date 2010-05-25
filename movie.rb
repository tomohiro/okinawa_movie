require 'rss'

class Movie
  def initialize
    @movies = RSS::Parser.parse('public/feed.xml').items
  end

  def all
    @movies
  end

  def each
    @movies.each { |m| yield m }
  end

  def find_by_screen(screen)
    @movies.find_all { |item| item.source.to_s.include? screen }
  end

  def find_by_title(title)
    @movies.find { |movie| movie.title.include? title }
  end
end
