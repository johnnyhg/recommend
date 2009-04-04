require 'set'
raise "selected_movies.rb training_set_dir full_movie_titles.txt > dest_movie_titles.txt" unless ARGV.length==2
TS_DIR, SRC_TITLES = ARGV
training_set_files = (`ls #{TS_DIR}`).split("\n")
mids = training_set_files.collect { |file| file.sub(/mv_0*/,'').sub('.txt','') }
IO.foreach(SRC_TITLES) do |line|
	mid = line.chomp.sub(/,.*/,'')
	puts line if mids.include? mid
end


