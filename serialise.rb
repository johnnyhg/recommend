require 'zlib'

module Serialise

	def self.write filename, data
#		puts "#{Time.now} > writing file #{filename}"
		f = Zlib::GzipWriter.new(File.new(filename, 'w'))
		f.write(Marshal.dump(data))
		f.close
#		puts "#{Time.now} < writing file #{filename}"
	end

	def self.read filename
#		puts "#{Time.now} > reading file #{filename}"
		f = Zlib::GzipReader.open(filename)
		data = Marshal.load(f.read)
		f.close
#		puts "#{Time.now} < reading file #{filename}"
		data
	end

end
