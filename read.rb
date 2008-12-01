module Read

	def self.all_movie_info 
		info = {}
		File.readlines(DATA_DIR + '/movie_titles.txt').collect do |line|
			id,year,name = line.chomp.split(',')
			info[id.to_i] = name
		end
		info
	end

	def self.movie_ratings mid
		filename = sprintf("/training_set/mv_%07d.txt",mid)
		lines = File.readlines(DATA_DIR + filename)
		lines.shift # useless header line
		user_to_rating = {}
		lines.collect do |line|
			user,rating,date = line.chomp.split(',')	
			user_to_rating[user.to_i] = rating.to_i
		end	
		user_to_rating
	end

end

