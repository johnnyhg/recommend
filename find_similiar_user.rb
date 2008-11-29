require 'coeffs.rb'

MIN_NUMBER_OF_COMMON_RATED = 4

#DATA_DIR = '/data/netflix'
DATA_DIR = 'test_data'

def read_all_movie_info
	File.readlines(DATA_DIR + '/movie_titles.txt').collect do |line|
		id,year,name = line.chomp.split(',')
		[id.to_i, name]
	end
end

def read_movie_ratings mid
	filename = sprintf("/training_set/mv_%07d.txt",mid)
	lines = File.readlines(DATA_DIR + filename)
	lines.shift # unless header line
	lines.collect do |line|
		user,rating,date = line.chomp.split(',')	
		[ user.to_i, rating.to_i ]
	end	
end

puts "parsing movie info"
movies_info = read_all_movie_info
movies_ids = movies_info.collect { |minfo| minfo[0] }

puts "building user => movie => rating hash"
user_movie_rating = {}
movies_ids.each do |mid|
	movie_ratings = read_movie_ratings mid
	movie_ratings.each do |rating|
		uid, rating = rating
		user_movie_rating[uid] ||= {}
		user_movie_rating[uid][mid] = rating
	end
end

user_ids = user_movie_rating.keys.sort
puts "user_ids #{user_ids.sort.inspect}"

uid = 1
puts "uid=#{uid}"
u_all_ratings = user_movie_rating[uid]
puts "u_all_ratings=#{u_all_ratings.inspect}"

ratings = []
num_users = user_ids.size

(0...num_users).each do |i|	
	puts "-" * 30		
	ouid = user_ids[i]
	puts "ouid=#{ouid}"
	ou_all_ratings = user_movie_rating[ouid]
	puts "ou_all_ratings=#{ou_all_ratings.inspect}"
	u_ratings, ou_ratings = Coeff.common u_all_ratings, ou_all_ratings
	next if u_ratings.size < MIN_NUMBER_OF_COMMON_RATED
	puts "u_ratings=#{u_ratings.inspect}"
	puts "ou_ratings=#{ou_ratings.inspect}"
	pearson_coeff = Coeff.pearson_coeff u_ratings, ou_ratings
	puts "pearson_coeff = #{pearson_coeff}"
	ratings << [ pearson_coeff, u_ratings.size, uid, ouid ]
end

ratings.sort! { |a,b| b[0] <=> a[0] } 
ratings.each { |r| puts r.inspect }
