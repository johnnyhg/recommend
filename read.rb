module Read

	#DATA_DIR = '/data/netflix'
	DATA_DIR = 'test_data'

	def self.all_movie_info
		File.readlines(DATA_DIR + '/movie_titles.txt').collect do |line|
			id,year,name = line.chomp.split(',')
			[id.to_i, name]
		end
	end

	def self.movie_ratings mid
		filename = sprintf("/training_set/mv_%07d.txt",mid)
		lines = File.readlines(DATA_DIR + filename)
		lines.shift # unless header line
		lines.collect do |line|
			user,rating,date = line.chomp.split(',')	
			[ user.to_i, rating.to_i ]
		end	
	end

end

