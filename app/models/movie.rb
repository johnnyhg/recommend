class Movie < ActiveRecord::Base

    has_many :reviews

    def self.with_most_reviews offset=1
        Movie.find(:first, :order => 'num_reviews desc, id asc', :offset=>offset)
    end

    def self.next_movie_to_review
        offset = 0
        while true do
            @next_movie_to_review = Movie.with_most_reviews offset
            puts "NMTR #{@next_movie_to_review}"
            return nil if @next_movie_to_review.nil?
            return @next_movie_to_review if Review.find_by_movie_id(@next_movie_to_review.id).nil?
            offset += 1
        end
    end

end
