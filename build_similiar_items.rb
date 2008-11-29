require 'coeffs.rb'
require 'read'

MIN_NUMBER_OF_COMMON_RATED = 4

puts "parsing movie info"
movies_info = Read.all_movie_info
movies_ids = movies_info.collect { |minfo| minfo[0] }

puts "building movie => user => rating hash"
movie_user_rating = {}
movies_ids.each do |mid|
	movie_ratings = Read.movie_ratings mid
	movie_ratings.each do |rating|
		uid, rating = rating
		movie_user_rating[mid] ||= {}
		movie_user_rating[mid][uid] = rating
	end
end

ratings = []
(0...movies_ids.size).each do |i|	
	mid = movies_ids[i]
	m_all_ratings = movie_user_rating[mid]
	(i+1...movies_ids.size).each do |j|	
		puts "-" * 30		
		omid = movies_ids[j]
		puts "mid=#{mid} omid=#{omid}"
		om_all_ratings = movie_user_rating[omid]
		puts "m_all_ratings=#{m_all_ratings.inspect}"
		puts "om_all_ratings=#{om_all_ratings.inspect}"
		m_ratings, om_ratings = Coeff.common m_all_ratings, om_all_ratings
#		next if u_ratings.size < MIN_NUMBER_OF_COMMON_RATED
		puts "m_ratings=#{m_ratings.inspect}"
		puts "om_ratings=#{om_ratings.inspect}"
		pearson_coeff = Coeff.pearson_coeff m_ratings, om_ratings
		puts "pearson_coeff = #{pearson_coeff}"
		ratings << [ pearson_coeff, m_ratings.size, mid, omid ]
	end
end

#ratings.sort! { |a,b| b[0] <=> a[0] } 
ratings.each { |r| puts r.inspect }
