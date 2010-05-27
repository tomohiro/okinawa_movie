require 'rss'

class ShowTime
  def initialize
    @list = RSS::Parser.parse('public/feed.xml').items
  end

  def all
    @list
  end

  def each
    @list.each { |m| yield m }
  end

  def find_by_theater(theater)
    @list.find_all { |movie| movie.source.to_s.include? theater }
  end

  def find_by_title(title)
    @list.find { |movie| movie.title.include? title }
  end
end
