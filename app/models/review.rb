class Review < ActiveRecord::Base
    belongs_to :movie
    validate :review_between_1_and_5

    def review_between_1_and_5
        errors.add_to_base "review should be >=1 and <=5 but is #{review}" unless review>=1 && review<=5
    end

end
