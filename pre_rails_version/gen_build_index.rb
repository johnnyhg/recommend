#!/usr/bin/env ruby
raise "usage gen_build_index N" unless ARGV.length==1
N = ARGV.first.to_i
N.times do |i|
    puts "ruby build_index.rb #{i+1} #{N}"
end

