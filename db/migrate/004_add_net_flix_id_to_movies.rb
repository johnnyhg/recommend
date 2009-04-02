class AddNetFlixIdToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :netflix_id, :integer
  end

  def self.down
    remove_column :movies, :netflix_id
  end
end
