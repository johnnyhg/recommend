#!/usr/bin/env ruby
raise "usage: index_info.rb idx_file" unless ARGV.length==1
require 'serialise'
idx = Serialise.read ARGV.first
keys = idx.keys
puts "movies: num=#{keys.length} min_id=#{keys.min} max_id=#{keys.max}"
min=1.0/0.0
max=-1.0/0.0
total=0
num=0
idx.each do |k,v|
	num += 1 
	num_reviews = v.keys.length
	total += num_reviews
	min = num_reviews if num_reviews < min
	max = num_reviews if num_reviews > max
end
puts "num reviews: total_num=#{total}"
puts "num reviews per movie: average=#{total.to_f/num} min=#{min} max=#{max}"
