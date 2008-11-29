require 'coeffs.rb'
require 'read.rb'

MIN_NUMBER_OF_COMMON_RATED = 4

puts "parsing movie info"
movies_info = Read.all_movie_info
movies_ids = movies_info.collect { |minfo| minfo[0] }

puts "building user => movie => rating hash"
user_movie_rating = {}
movies_ids.each do |mid|
	movie_ratings = Read.movie_ratings mid
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
