#!/usr/bin/env ruby
require 'read'
require 'movies'
require 'serialise'
require 'coeffs'
require 'db'

MIN_NUMBER_OF_COMMON_RATED = 4
MAX_SIMILIAR_ITEMS = 3

class Similiarity 
	def read_index i1, i2
		@idx1, @idx2 = [i1,i2].collect do |idx_num|
			idx_file_name = "#{INDEX_FILE_PREFIX}_#{idx_num}_*.dat"
			idx_files = `ls #{idx_file_name}`.split "\n"
			raise "no idx file for #{idx_file_name}" if idx_files.empty?
			raise "more than one file matched #{idx_file_name}" if idx_files.size > 1
			hash = Serialise.read idx_files.first
			#puts "idx_file_name #{idx_file_name} hash #{hash.inspect}"
			hash
		end
	end

	def build_similiarity
		db = Db.new()
		@idx1.keys.each do |k1|
			m1_all_ratings = @idx1[k1]
			@idx2.keys.each do |k2|
				next if k1 >= k2
				m2_all_ratings = @idx2[k2]				
				pearson_coeff = Coeff.pearson_coeff m1_ratings, m2_ratings
				db.update k1, k2, pearson_coeff
				#puts "idx1key #{k1} idx2key #{k2} pearson_coeff #{pearson_coeff}"				
			end
		end
		db.close()
	end

	def dot_output
		edges = [] # [ n1, n2, sim ]
		m = @movies.movies
		m.keys.each do |node|
			m[node].similiar.to_a.each do |sim_onode|
				# todo add set here so only add  one way (ie if added a->b don't add b->a)
				sim,onode = sim_onode
				edges << [ node, onode, sim ]
			end
		end

		# todo: normalise to 0 -> 1 (ie shift smallest to 0 and scale out to 1)

		puts <<-EOF
		graph G {
		graph [splines=true overlap=false]
		EOF

		movies_info = Read.all_movie_info 
		edges.each do |e| 
			printf "\"#{movies_info[e[0]]}\" -- \"#{movies_info[e[1]]}\" [label=\"%0.2f\"];\n", (e[2]+1)/2
		end
		puts "}"
	end
end

if ARGV.length==2
	IDX1, IDX2 = ARGV
elsif ARGV.length==0
	IDX1 = IDX2 = 1
else
    raise "build_similiar_items.rb IDX1=1 IDX2=1"
end


similiarity = Similiarity.new
similiarity.read_index IDX1, IDX2
similiarity.build_similiarity
#similiarity.dot_output

