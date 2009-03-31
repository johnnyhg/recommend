class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.column :movie_id, :integer
      t.column :review, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
