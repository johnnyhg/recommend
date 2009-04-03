class CreateTableSimilarites < ActiveRecord::Migration

  def self.up
    create_table :similarities, :id => false do |t|
      t.column "mid1", :string
      t.column "mid2", :integer
      t.column "similarity", :float      
    end
  end

  def self.down
      Movie.connection.execute "update movies set similarities_calculated='false'"
      drop_table :similarities
  end

end
