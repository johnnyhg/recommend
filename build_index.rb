require 'read'
require 'consts'

if ARGV.length==2
	CHUNK, NUM_CHUNKS = ARGV.map { |a| a.to_i }
else
	CHUNK = NUM_CHUNKS = 1
end

puts "parsing movie info"
movies_info = Read.all_movie_info
movies_ids = movies_info.keys.chunk(CHUNK, NUM_CHUNKS)

movies_ids = movies_ids.slice(0,100) # HACK!

puts "building movie => user => rating hash"
movie_user_rating = {}
movies_ids.each_with_index do |mid, idx|
	puts "parse mid #{mid} (#{idx}/#{movies_ids.length})"
	movie_user_rating[mid] = Read.movie_ratings mid
end

Serialise.write "#{INDEX_FILE_PREFIX}_#{CHUNK}_#{NUM_CHUNKS}.dat", movie_user_rating
