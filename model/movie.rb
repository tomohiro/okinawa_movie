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
      end
    end

    def reset
      drop_table
      setup
      create_table
    end

    # Get movie titles from the STAR THEATERS.
    # url: http://www.startheaters.jp/now_showing.html
    def startheaters
      distinct(:title).grep(:url, '%startheaters%').order(:title)
    end

    # Get movie titles from the Sakurazaka.
    # url: http://www.google.com/movies?tid=3d1a4be489681836&near=%E9%82%A3%E8%A6%87%E5%B8%82
    def sakurazaka
      grep(:url, '%google%').order(:title)
    end
  end

  def showtimes
    Movie.filter({ :title => Movie[self.id].title }, ['start > ?', Time.now.strftime('%H:%M')])
  end

  unless table_exists?
    setup
    create_table
  end
end
