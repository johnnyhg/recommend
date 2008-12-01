class Movies
	attr_reader :movies

	def initialize
		@movies = {}
	end

	def add_similiarity mid1, mid2, similiarity
		@movies[mid1] ||= Movie.new()
		@movies[mid2] ||= Movie.new()
		@movies[mid1].add_similiar mid2, similiarity
		@movies[mid2].add_similiar mid1, similiarity
	end

end

class Movie
	attr_accessor :id
	attr_reader :similiar

	def initialize
		@similiar = MultiRBTree.new
	end

	def add_similiar mid, similiarity
		return if @similiar.length == MAX_SIMILIAR_ITEMS and similiarity < @similiar.min[0]
		@similiar[similiarity] = mid
		@similiar.delete @similiar.min[0] if @similiar.size > MAX_SIMILIAR_ITEMS
	end

end
