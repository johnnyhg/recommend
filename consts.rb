require 'zlib'

#DATA_DIR = 'test_data'
DATA_DIR = 'test_data_small'
#DATA_DIR = '/data/netflix'

INDEX_FILE_PREFIX = "movie_user_rating_idx_"

class Array 

	def chunk(chunk, num_chunks)
		offset, interval = offset_and_interval(chunk, num_chunks)
		slice offset, interval
	end

	def offset_and_interval(chunk, num_chunks) 
		raise "require 1 <= chunk(#{chunk}) <= num_chunks(#{num_chunks})" unless 1<=chunk and chunk<=num_chunks 
		chunk_size = (length.to_f / num_chunks).ceil
		offset = (chunk-1) * chunk_size
		[ offset, chunk_size ]
	end
end

module Serialise

	def self.write filename, data
		puts "#{Time.now} > writing file #{filename}"
		f = Zlib::GzipWriter.new(File.new(filename, 'w'))
		f.write(Marshal.dump(data))
		f.close
		puts "#{Time.now} < writing file #{filename}"
	end

	def self.read filename
		puts "#{Time.now} > reading file #{filename}"
		f = Zlib::GzipReader.open(filename)
		data = Marshal.load(f.read)
		f.close
		puts "#{Time.now} < reading file #{filename}"
		data
	end

end
