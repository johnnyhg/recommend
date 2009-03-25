#!/usr/bin/env ruby
raise "usage gen_similiarity_script N" unless ARGV.length==1
N = ARGV.first.to_i
N.times do |i|
	N.times do |j|
		puts "ruby build_similiar_items.rb #{i+1} #{j+1} > output.#{i+1}.#{j+1}"
	end
end

