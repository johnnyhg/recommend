class RecommendationsController < ApplicationController

    def index
        reviews = Review.find(:all, :conditions => 'rating>0')
        if reviews.size==0            
            @recommendations=[]
            return
        end
        unseen_movies = Movie.find(:all).select { |m| Review.find_by_movie_id(m.id).nil? }
        puts "reviews given #{reviews.collect{|r| r.movie.name}.inspect}"
        puts "unseen_movies #{unseen_movies.collect(&:name).inspect}"
        @recommendations = unseen_movies.collect do |unseen_movie|
            similarities_sum = 0
            similarities_x_review_sum = 0
            reviews.each do |review|
                similarity = unseen_movie.get_similarity_to review.movie
                similarities_sum += similarity
                similarities_x_review_sum += similarity * review.rating

                puts "similarity of #{unseen_movie.name} to #{review.movie.name} "+
                        "rating (#{review.rating}) "+             
                        "is #{similarity}. "+
                        "similarities_sum=#{similarities_sum}, " +
                        "similarities_x_review_sum=#{similarities_x_review_sum}"
                
            end
            expected_rating = similarities_x_review_sum / similarities_sum
            puts "so expected rating for #{unseen_movie.name} is #{expected_rating}"
            [unseen_movie.name, expected_rating]
        end
        @recommendations.sort! {|r1,r2| r2[1]<=>r1[1]}
    end

end