require 'coeffs'
require 'read'
require 'rubygems'
require 'rbtree'
require 'movies'

MIN_NUMBER_OF_COMMON_RATED = 4
MAX_SIMILIAR_ITEMS = 3
DATA_DIR = 'test_data_small'

puts "parsing movie info"
movies_info = Read.all_movie_info
movies_ids = movies_info.keys

puts "building movie => user => rating hash"
movie_user_rating = {}
movies_ids.each_with_index do |mid,idx|
	puts "parse mid #{mid} (#{idx}/#{movies_ids.length})"
	movie_user_rating[mid] = Read.movie_ratings mid
end

movies = Movies.new
(0...movies_ids.size).each do |i|
	mid = movies_ids[i]
	puts "process mid #{mid} (#{i}/#{movies_ids.size})"	
	m_all_ratings = movie_user_rating[mid]
	(i+1...movies_ids.size).each do |j|	
#		puts "-" * 30		
		omid = movies_ids[j]
#		puts "mid=#{mid} omid=#{omid}"
		om_all_ratings = movie_user_rating[omid]
#		puts "m_all_ratings=#{m_all_ratings.inspect}"
#		puts "om_all_ratings=#{om_all_ratings.inspect}"
		m_ratings, om_ratings = Coeff.common m_all_ratings, om_all_ratings
#		next if u_ratings.size < MIN_NUMBER_OF_COMMON_RATED
#		puts "m_ratings=#{m_ratings.inspect}"
#		puts "om_ratings=#{om_ratings.inspect}"
		pearson_coeff = Coeff.pearson_coeff m_ratings, om_ratings
#		puts "pearson_coeff = #{pearson_coeff}"
		movies.add_similiarity mid, omid, pearson_coeff
	end
end

edges = [] # [ n1, n2, sim ]
m = movies.movies
m.keys.each do |node|
	m[node].similiar.to_a.each do |sim_onode|
		# todo add set here so only add  one way (ie if added a->b don't add b->a)
		sim,onode = sim_onode
		edges << [ node, onode, sim ]
	end
end

# todo: normalise to 0 -> 1 (ie shift smallest to 0 and scale out to 1)

puts <<EOF
graph G {
graph [splines=true overlap=false]
EOF
edges.each do |e| 
	printf "\"#{movies_info[e[0]]}\" -- \"#{movies_info[e[1]]}\" [label=\"%0.2f\"];\n", (e[2]+1)/2
end
puts "}"

