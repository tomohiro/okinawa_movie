require 'kconv'
require 'sequel'

Sequel::Model.plugin :schema
Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/movies.db')

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
      theaters = %w[[シネマQ] [サザンプレックス] [ミハマ7プレックス] [シネマパレット]]
      movies_from_titles(select(:title).filter(:theater => theaters).group(:title).all)
    end

    def sakurazaka
      movies_from_titles(select(:title).filter(:theater => '[桜坂劇場]').group(:title).all)
    end

    def showtime(id)
      ENV['TZ'] = 'Asia/Tokyo'
      filter({:title => self[id].title} & (:start > Time.now.strftime('%H:%M')))
    end

    private

    def movies_from_titles(titles)
      movies = []
      titles.each do |t|
        movies << filter(:title => t.title).first
      end
    end
  end

  unless table_exists?
    setup
    create_table
  end
end
