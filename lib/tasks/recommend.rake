 namespace :db do
    desc "load movies"
    task :load_movies => :environment do
        Movie.delete_all
        File.new(DATA_DIR+'/movie_titles.txt').each do |line|
            netflix_id,year,name = line.chomp.split ','
            training_set_filename = sprintf("/training_set/mv_%07d.txt",netflix_id)
            num_reviews = `cat #{DATA_DIR}#{training_set_filename} | wc -l`
            Movie.create! :netflix_id=>netflix_id, :year=>year, :name=>name, :num_reviews=>num_reviews
        end.close
    end
 end

 namespace :index do
    desc "build single file index"
    task :build => :environment do
        movie_user_rating = {}
        movies = Movie.find(:all)
        movies.each_with_index do |movie, idx|
            puts "parse movie #{movie.name} (#{idx}/#{movies.length})"
            movie_user_rating[movie.id] = movie.index_entry_for_ratings
        end
        Serialise.write INDEX_FILE, movie_user_rating
    end
 end

 namespace :reviews do
     desc "delet all reviews"
     task :reset  => :environment do
         Review.delete_all
     end
 end

 namespace :similarities do
     desc "reset all similiarities"
     task :reset  => :environment do
        Movie.connection.execute 'truncate table similarities'
        Movie.connection.execute "update movies set similarities_calculated='false'"
     end                                                      
 end