class RecommendationsController < ApplicationController

    def index
        
        if Review.count==0
            @recommendations=[]
            return
        end

        reviews = Review.find(:all, :conditions => 'rating>0')
        
        movies_declared_unseen = Review.find(:all, :conditions => 'rating=0').collect { |r| r.movie }
        movies_totally_unknown = Movie.find(:all).select { |m| Review.find_by_movie_id(m.id).nil? }         
        unseen_movies = movies_declared_unseen + movies_totally_unknown

        puts "reviews given #{reviews.collect{|r| r.movie.name}.sort.inspect}"
        puts "movies_declared_unseen #{movies_declared_unseen.collect(&:name).sort.inspect}"
        puts "movies_totally_unknown #{movies_totally_unknown.collect(&:name).sort.inspect}"

        @recommendations = unseen_movies.collect do |unseen_movie|
            similarities_sum = 0
            similarities_x_review_sum = 0
            reviews.each do |review|
                similarity = unseen_movie.get_similarity_to review.movie
                similarities_sum += similarity
                similarities_x_review_sum += similarity * review.rating

#                puts "similarity of #{unseen_movie.name} to #{review.movie.name} "+
#                        "rating (#{review.rating}) "+
#                        "is #{similarity}. "+
#                        "similarities_sum=#{similarities_sum}, " +
#                        "similarities_x_review_sum=#{similarities_x_review_sum}"
                
            end
            expected_rating = similarities_x_review_sum / similarities_sum
            puts "so expected rating for #{unseen_movie.name} is #{expected_rating}"
            [unseen_movie.name, expected_rating]
        end
        @recommendations.sort! {|r1,r2| r2[1]<=>r1[1]}
    end

end