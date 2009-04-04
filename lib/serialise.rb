require 'zlib'
#puts ">serialise"

module Serialise

    def self.write filename, data
        f = Zlib::GzipWriter.new(File.new(filename, 'w'))
        f.write(Marshal.dump(data))
        f.close
    end

    def self.read filename
        f = Zlib::GzipReader.open(filename)
        data = Marshal.load(f.read)
        f.close
        data
    end

end
