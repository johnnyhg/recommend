class ReviewsController < ApplicationController

    def index
        @reviews = Review.find(:all)
    end

    def new
        @next_movie_to_review = Movie.next_movie_to_review
        redirect_to :action => :index if @next_movie_to_review.nil?
    end

    def create        
        movie  = Movie.find(params['review']['movie'])
        rating = params['review']['rating']
        puts "movie #{movie} rating #{rating}" 
        Review.create! :movie => movie, :rating => rating
        redirect_to :action => :new
    end

    def destroy
        Review.find(params['id']).destroy
        redirect_to :action => :index
    end
    
end
