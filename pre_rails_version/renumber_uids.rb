#!/usr/bin/env ruby
raise "usage: renumber_uids.rb SRC_DIR DEST_DIR" unless ARGV.length==2
SRC_DIR, DEST_DIR = ARGV
raise "src dir '#{SRC_DIR}' doesnt exist" unless File.directory? SRC_DIR

require 'ftools'

uid_mapping = []

uid_seq = 0

File.makedirs "#{DEST_DIR}"

Dir.glob("#{SRC_DIR}/*").each do |filepath|
    puts "processing #{filepath}"
    filename = filepath.sub /.*\//, ''
    outfile = File.new "#{DEST_DIR}/#{filename}", 'w'
    File.open(filepath).each do |line|
        line =~ /(.*?),(.*)/
        old_uid,review = $1.to_i, $2 
        new_uid = uid_mapping[old_uid]
        if new_uid.nil?
            new_uid = uid_seq
            uid_seq += 1
            uid_mapping[old_uid]
        end
        outfile.puts "#{new_uid},#{review}"
    end.close
    outfile.close
end

