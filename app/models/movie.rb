class Movie < ActiveRecord::Base
  def self.fetch_ratings
    ratings = []
    Movie.all.each do |movie|
	      if (!ratings.find_index(movie.rating))
	        	ratings.push(movie.rating)
	      end
    end
    return ratings
  end
end
