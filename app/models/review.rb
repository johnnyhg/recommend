class Review < ActiveRecord::Base
    belongs_to :movie
    validate :review_between_0_and_5

    def review_between_0_and_5
        errors.add_to_base "rating should be >=0 and <=5 but is #{rating}" unless rating>=0 && rating<=5
    end

    def after_save
        return if movie.similarities_calculated
        already_calculated_movies = Review.find(:all).collect { |r| r.movie_id }
        mid1 = movie.id
        Movie.find(:all).each do |other_movie|
            next if other_movie == movie                # dont compare to self
            next if other_movie.similarities_calculated # dont redo similiarity
            mid2 = other_movie.id
            mid1,mid2 = mid2,mid1 if mid1 > mid2 # to make lookup easier
            similarity = Coeff.pearson_coeff INDEX[mid1], INDEX[mid2]
            query = "insert into similarities (mid1,mid2,similarity) values (#{mid1},#{mid2},#{similarity});"
            Movie.connection.execute(query)
        end
        movie.similarities_calculated = true
        movie.save!
    end
    
end
