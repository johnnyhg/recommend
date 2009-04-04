require 'rubygems'
require 'highline'
include HighLine::SystemExtensions
require 'yaml'

# query the user on command line about what
# rating _they_ would give for various films

# run as self_rate.rb BOOTSTRAP first time or to clear ratings
#
# run as self_rate.rb and answer ratings (will pick up from where you got up to last time)
#  1->5 crap to awesome
#  0 if you havent seen the movie
#  q if you're bored and want to come back later
#
# apps asks about films in the order of most to least number of ratings 

DATA_DIR = '/data/netflix'
#DATA_DIR = 'test_data'

def read_num_ratings_to_movie_id_hash
	freqs = {}
	File.readlines(DATA_DIR+'/wc_l').each do |line|
		line =~ /(.*) mv_(.*)\.txt/
		freq, movie_id = $1.to_i,$2.to_i		
		freqs[movie_id] = freq
	end
	freqs
end

def valid(char)
 (char >= '0' and char <= '5' ) or char=='q'
end
 
def rate(item)
 id,name,year = item
 char = '$'
 while not valid(char) do
  print "#{name} (#{year})? "
  char = get_character.chr
  print "#{char}\n"
 end
 char=='q' ? :exit : [id,char.to_i]
end

def write_ratings_yaml movie_id_to_rating, unrated_movie_id_to_movie_info
	puts "writing ratings to disk..."
  file = File.open("ratings.yaml","w")
  YAML.dump( [movie_id_to_rating, unrated_movie_id_to_movie_info], file)
  file.close
end

def bootstrap
	puts "bootstrapping...."
	`mv ratings.yaml ratings.yaml.bak`

	movie_info = File.readlines(DATA_DIR + '/movie_titles.txt').collect do |line|
		id,year,name = line.chomp.split(',')
		id,year = id.to_i,year.to_i
		[id, name, year]
	end

	ratings_freq = read_num_ratings_to_movie_id_hash
	movie_info.sort! { |a,b| ratings_freq[b.first] <=> ratings_freq[a.first] }

	write_ratings_yaml([], movie_info)
end

bootstrap if ARGV.length==1 and ARGV[0]=='BOOTSTRAP' 

rated,unrated = YAML.load(File.read('ratings.yaml'))
new_ratings = []
rating = :bootstrap
while (not(rating == :exit or unrated.empty?)) do
	next_unrated = unrated.first
	rating = rate(next_unrated)
	if rating != :exit
		new_ratings << rating
		unrated.shift
	end
end
rated += new_ratings
write_ratings_yaml rated, unrated



