class Movie < ActiveRecord::Base

    has_many :reviews

    def self.with_most_reviews offset=1
        Movie.find(:first, :order => 'num_reviews desc, id asc', :offset=>offset)
    end

    def self.next_movie_to_review
        offset = 0
        while true do
            @next_movie_to_review = Movie.with_most_reviews offset
            return nil unless @next_movie_to_review
            review_for_movie = Review.find_by_movie_id(@next_movie_to_review.id)
            return @next_movie_to_review unless review_for_movie
            offset += 1
        end
    end

    def index_entry_for_ratings
        filename = sprintf "%s/training_set/mv_%07d.txt", DATA_DIR,netflix_id
        user_and_rating = []
        File.open(filename).each do |line|
            user,rating,date = line.chomp.split(',')
            user_and_rating << user.to_i
            user_and_rating << rating.to_i
        end.close
        user_and_rating
    end

end
