class AddHasCalcdSimiliaritiesToMovies < ActiveRecord::Migration
    
  def self.up
      add_column :movies, :similarities_calculated, :boolean
  end

  def self.down
      remove_column :movies, :similarities_calculated      
  end
    
end
