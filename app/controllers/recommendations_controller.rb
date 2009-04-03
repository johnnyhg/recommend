class RecommendationsController < ApplicationController

    def index
        reviews = Reviews.find(:all)        
    end

end