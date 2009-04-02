require 'consts'
require 'set'

module Read

	def self.all_movie_info 
		info = {}
		File.open(DATA_DIR + '/movie_titles.txt').each do |line|				
			id,year,name = line.chomp.split(',')
			info[id.to_i] = name
		end.close
		info
	end

    def self.users_given_ratings_for_movie mid
        ids = Set.new
        filename = sprintf("/training_set/mv_%07d.txt",mid)
        File.open(DATA_DIR + filename).each do |line|
            line =~ /(.*),/
            ids << $1.to_i
        end.close
        ids
    end

    # MOVED TO MOVIE

end

