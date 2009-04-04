require 'set'
raise "selected_users.rb id_file src_data_dir dest_data_dir" unless ARGV.length==3
ID_FILE, SRC_DATA_DIR, DEST_DATA_DIR = ARGV
src_ids = Set.new(File.readlines(ID_FILE).map {|line| line.chomp})
`mkdir #{DEST_DATA_DIR}`
`ls #{SRC_DATA_DIR}`.each do |file|
    file.chomp!
    dest = File.open("#{DEST_DATA_DIR}/#{file}","w")
    IO.foreach("#{SRC_DATA_DIR}/#{file}") do |line|
        if !!(line =~ /:$/)
            dest.puts line
        else
            line =~ /(.*?),/; id = $1
            dest.puts line if (src_ids.include? id)           
        end
    end
    dest.close
end
