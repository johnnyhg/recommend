class Review < ActiveRecord::Base
    belongs_to :movie
    validate :review_between_0_and_5

    def review_between_0_and_5
        errors.add_to_base "rating should be >=0 and <=5 but is #{rating}" unless rating>=0 && rating<=5
    end

    def after_save
        
    end
end
