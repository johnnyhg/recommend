namespace :db do
    desc "load movies"
    task :load_movies => :environment do
        Movie.delete_all
        File.new(DATA_DIR+'/movie_titles.txt').each do |line|
            id,year,name = line.chomp.split ','
            training_set_filename = sprintf("/training_set/mv_%07d.txt",id)
            num_reviews = `cat #{DATA_DIR}#{training_set_filename} | wc -l`
            Movie.create! :id=>id, :year=>year, :name=>name, :num_reviews=>num_reviews
        end.close
    end
end