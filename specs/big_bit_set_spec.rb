require 'big_bit_set.rb'

describe 'set bits' do

	before :each do
		@bbs = BigBitSet.new
	end

	it 'should start with bits unset' do
		@bbs.num[0].should == 0
	end

	it "should be able to set bits" do
		@bbs.set_bit 3
		@bbs.num[0].should == 2**3
	end

	it "should be able to set a bit and unset it" do
		@bbs.set_bit 3
		@bbs.unset_bit 3
		@bbs.num[0].should == 0
	end

	it "should be able to set a number of bits at once" do
		bbs2 = BigBitSet.new 
		@bbs.set_bit 2
		@bbs.set_bit 4
		@bbs.set_bit 7
		bbs2.set_bits [2,4,7]
		@bbs.num[0].should == bbs2.num[0]
	end

	it "should be able to unset a number of bits at once" do
		@bbs.set_bit 2
		@bbs.set_bit 4
		@bbs.set_bit 7
		@bbs.unset_bits [2,4,7]
		@bbs.num[0].should == 0
	end

	it "should be able to determine if there are no bits in common" do
		@bbs.set_bits [2,3,4]
		bbs2 = BigBitSet.new
		bbs2.set_bits [5,6,7]
		@bbs.any_bits_common_with(bbs2).should be_false
	end

	it "should be able to determine if there is at least one bit in common" do
		@bbs.set_bits [2,3,4]
		bbs2 = BigBitSet.new
		bbs2.set_bits [4,5,6,7]
		@bbs.any_bits_common_with(bbs2).should be_true
	end

end
