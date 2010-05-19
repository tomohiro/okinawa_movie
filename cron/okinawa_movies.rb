#!/usr/bin/env ruby

require 'open-uri'
require 'rss'
require 'rubygems'
require 'nokogiri'

$KCODE = 'u'

class OkinawaMovies 
  def initialize
    @theaters_uri = [
      'http://www.startheaters.jp/schedule',
      'http://www.google.co.jp/movies?tid=3d1a4be489681836'
    ]
  end

  def self.rss
    new.rss
  end

  def rss 
    movies = get_screen_time

    RSS::Maker.make('2.0') do |maker|
      maker.channel.about = 'http://okinawa-movie.heroku.com/feed.xml'
      maker.channel.title = '沖縄県映画上映時間一覧'
      maker.channel.description = '沖縄県内の映画の上映時間を配信しています'
      maker.channel.link = 'http://okinawa-movie.heroku.com/'

      maker.items.do_sort = true

      movies.each do |movie|
        maker.items.new_item do |item|
          item.link = movie[:link]
          item.title = movie[:title]
          item.description = movie[:time]
          item.date = Time.now
        end
      end
    end
  end

  def get_screen_time
    results = []

    @theaters_uri.each do |theater|
      html = Nokogiri::HTML(open(theater).read)

      if theater.include? 'startheaters'
        (html/'div.unit_block').each do |movie_info|
          item = {}
          item[:title] = movie_info.at('h3/a').text
          item[:link]  = movie_info.at('div.pic_block/a[@target="_blank"]').attributes['href']
          item[:time]  = ''

          (movie_info/'table.set_d').each do |screen|
            movie = ["[#{screen.at('th.cinema/img').attributes['alt']}]"]
            (screen/'td').each do |time|
              movie << time.text unless time.text.to_i == 0
            end
            item[:time] << movie.join('  ') + '<br>'
          end
          results << item
        end
      else
        (html/'div.movie').each do |info|
          item = {}
          item[:title] = (info/'div.name/a/span[@dir="ltr"]').text
          item[:link]  = 'http://www.sakura-zaka.com/'
          item[:time]  = "[桜坂劇場] #{info.inner_html.scan(/(..:..+?)</).last}"
          results << item
        end
      end
    end

    results
  end
end

if __FILE__ == $0
  puts OkinawaMovies.rss
end
