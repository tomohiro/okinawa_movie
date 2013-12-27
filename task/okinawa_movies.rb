#!/usr/bin/env ruby
# encoding:utf-8

require 'open-uri'
require 'nokogiri'

require 'model/movie.rb'

class OkinawaMovies
  def initialize
    @theaters_uri = [
      'http://www.startheaters.jp/now_showing.html',
       "http://www.google.com/movies?tid=3d1a4be489681836&near=#{URI.escape('那覇市')}"
    ]
  end

  def update(reset = true)
    Movie.reset if reset

    get_showtime.each do |showtime|
      Movie.create(showtime)
    end
  end

  def get_showtime
    showtimes = []

    @theaters_uri.each do |theater|
      html = Nokogiri::HTML(open(theater))

      if theater.include? 'startheaters'
        html.search('.movieThumbBox').each do |movie|
          title  = movie.at('.movieTtl').text
          url    = "http://www.startheaters.jp/#{movie.at('.detailBtn/a').attributes['href']}"
          poster = movie.at('.flyer/img').attributes['src'].value

          movie_detail_page = Nokogiri::HTML(open(url))
          movie_detail_page.search('.MovieScheduleBox').each do |schedule|
            theater = theater_name(schedule.at('.theaterInfo/dd').attributes['class'].value)
            schedule.search('.sowtimesList/li').each do |showtime|
              showtimes << {
                title: title,
                url: url,
                poster: poster,
                theater: theater,
                start: showtime.at('.startTime').text,
                end: showtime.at('.endTime').text.gsub([0XFF5E].pack('U'), ''),
              }
            end
          end
        end
      else
        html.search('.movie').each do |movie|
          movie.search('.times/span').each do |showtime|
            showtimes << {
              title: movie.at('.name/a').text,
              url: "http://www.google.com#{movie.at('.name/a').attributes['href'].value}",
              poster: '',
              theater: '桜坂劇場',
              start: "#{showtime.text.gsub('&nbsp', '').gsub(' ', '')}",
              end: '',
            }
          end
        end
      end
    end

    showtimes
  end

  private
    def theater_name(theater_id)
      theaters = {
        'theaterQ' => 'シネマQ',
        'theaterS' => 'ミハマ7プレックス',
        'theater7' => 'サザンプレックス',
        'theaterP' => 'シネマパレット'
      }
      theaters[theater_id]
    end
end
