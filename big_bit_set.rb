#!/usr/bin/env ruby 

# supports up to 500,000 bits

class BigBitSet

  NUM_SIZE = 100000
  NUM_NUMS = 5

	attr_accessor :num

	def initialize
		@num = [0] * NUM_NUMS
	end

	def set_bits bits
		bits.each { |b| set_bit b }
	end

	def set_bit bit
		idx = bit / NUM_SIZE
		offset = bit % NUM_SIZE
		@num[idx] |= (1 << offset)
	end

	def dump
		@num.each { |n| printf "%x\n", n }
	end

	def num_bits_set
		@num.inject(0){ |count,num| count + num_bits_set(num) }
	end

  def num_bits_set_in_common other
		count = 0 
    (0...NUM_NUMS).each do |idx|
			count += num_bits_set(@num[idx] & other.num[idx])
		end
		count
  end

	private

	def num_bits_set num
		count = 0 
		while num!=0 do
			count += 1
			num &= num-1
		end
		count
	end
end

#f = File.open 'fsdf','w'
#f.write(Marshal.dump(bbs1.num[0]))
#f.close

#f = File.open 'fsdf','r'
#num = Marshal.load(f.read)
#printf("%x\n",num)

