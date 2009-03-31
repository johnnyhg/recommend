class Movie < ActiveRecord::Base

    def self.with_most_reviews offset=1
        Movie.find(:first, :order => 'num_reviews DESC', :offset=>offset)
    end

end
