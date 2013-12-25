#!/usr/bin/env ruby
# encoding:utf-8

require 'open-uri'
require 'rss'
require 'rubygems'
require 'nokogiri'

require 'model/movie.rb'

class OkinawaMovies
  def initialize
    @theaters_uri = [
      'http://www.startheaters.jp/schedule',
      "http://www.google.com/movies?tid=3d1a4be489681836&near=#{URI.escape('那覇市')}"
    ]
  end

  def migrate(reset = true)
    Movie.reset if reset

    get_showtime.each do |showtime|
      showtime[:time].split('<br>').each do |info|
        info = info.split(' ')
        theater = info.shift

        info.each do |time|
          Movie.create({
            :title   => showtime[:title].toutf8,
            :theater => theater.toutf8,
            :poster  => '',
            :url     => showtime[:source_url].toutf8,
            :start   => (time.split([0XFF5E].pack('U'))[0]).toutf8,
            :end     => (time.split([0XFF5E].pack('U'))[1]) || '',
            :date    => Time.now
          })
        end
      end
    end
  end

  def get_showtime
    results = []

    @theaters_uri.each do |theater|
      html = Nokogiri::HTML(open(theater).read)

      if theater.include? 'startheaters'
        (html/'div.unit_block').each do |movie_info|
          item = {}
          item[:source_url] = theater
          item[:source_content] = 'スターシアターズ'
          item[:title] = movie_info.at('h3/a').text.gsub('　', '')
          item[:link]  = movie_info.at('div.pic_block/a[@target="_blank"]').attributes['href'] rescue theater
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
          item[:source_url] = theater
          item[:source_content] = '桜坂劇場'
          item[:title] = (info/'div.name/a').text
          item[:link]  = 'http://www.sakura-zaka.com/'
          item[:time]  = "[桜坂劇場] #{info.inner_html.scan(/(..:..+?)</).last}"
          results << item
        end
      end
    end

    results
  end
end
