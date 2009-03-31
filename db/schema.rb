# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "completed_runs", :id => false, :force => true do |t|
    t.integer "mid"
  end

  add_index "completed_runs", ["mid"], :name => "completed_runs_idx"

  create_table "movies", :force => true do |t|
    t.string   "name"
    t.integer  "num_reviews"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "similarity", :id => false, :force => true do |t|
    t.integer "mid1"
    t.integer "mid2"
    t.float   "coeff"
  end

  add_index "similarity", ["mid1", "mid2"], :name => "similarity_m12_idx"

  create_table "similarity2", :id => false, :force => true do |t|
    t.integer "mid1"
    t.integer "mid2"
    t.float   "coeff"
  end

end
