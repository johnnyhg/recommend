#puts "> loading index"
INDEX = File.exists?(INDEX_FILE) ? Serialise.read(INDEX_FILE) : {}
#puts "< loading index"