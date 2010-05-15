#!/usr/bin/env ruby

require 'open-uri'
require 'rubygems'
require 'nokogiri'

$KCODE = 'u'

class GetScreenTime
  def initialize
    @theaters_uri = [
      'http://www.startheaters.jp/schedule',
      'http://www.google.co.jp/movies?tid=3d1a4be489681836'
    ]
  end

  def get_screen_time
    results = []

    @theaters_uri.each do |theater|
      html = Nokogiri::HTML(open(theater).read)

      if theater.include? 'startheaters'
        (html/'div.unit_block').each do |movie_info|
          title = movie_info.at('h3/a').text

          site  = movie_info.at('div.pic_block/a[@target="_blank"]').attributes['href']
          results << "#{title.gsub('　', '')}  #{site}"

          (movie_info/'table.set_d').each do |screen|
            movie = [" - [#{screen.at('th.cinema/img').attributes['alt']}]"]
            (screen/'td').each do |time|
              movie << time.text unless time.text.to_i == 0
            end
            results << movie.join('  ')
          end
        end
      else
        results << '[桜坂劇場] (http://www.sakura-zaka.com/)'

        (html/'div.movie').each do |info|
          movie_title = (info/'div.name/a/span[@dir="ltr"]').text

          time = info.inner_html.scan(/(..:..+?)</).last
          results << "#{movie_title} #{time}"
        end
      end
    end

    results
  end
end

if __FILE__ == $0
  puts GetScreenTime.new.get_screen_time
end
