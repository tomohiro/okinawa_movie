# encoding:utf-8

require 'kconv'
require 'sequel'

Sequel::Model.plugin :schema
Sequel.connect((ENV['DATABASE_URL'] || 'sqlite://db/movies.db'))

class Movie < Sequel::Model
  class << self
    def setup
      set_schema do
        primary_key :id
        text :title
        text :theater
        text :poster
        text :url
        text :start
        text :end
        timestamp :date
      end
    end

    def reset
      drop_table
      setup
      create_table
    end

    def startheaters
      # url: http://www.startheaters.jp/schedule
      distinct(:title).grep(:url, '%startheaters%').order(:title)
    end

    def sakurazaka
      # url: http://www.google.com/movies?tid=3d1a4be489681836&near=%E9%82%A3%E8%A6%87%E5%B8%82
      grep(:url, '%google%').order(:title)
    end

  end

  def showtimes
    ENV['TZ'] = 'Asia/Tokyo'
    Movie.filter({ :title => Movie[self.id].title }, ['start > ?', Time.now.strftime('%H:%M')])
  end


  unless table_exists?
    setup
    create_table
  end
end
