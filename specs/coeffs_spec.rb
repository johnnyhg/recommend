require 'coeffs.rb'

describe 'common value extraction' do

	it 'should return nothing for two hashes with nothing in common' do
		ha = { :a => 3, :b => 4, }
		hb = {                   :c => 12, :d => 66 }
		a,b = Coeff.common ha,hb
		a.should be_empty
		b.should be_empty
	end

	it 'should return only the items in common when there are additional non common items' do
		ha = { :a => 3, :b => 4, }
		hb = {          :b => 12, :d => 66 }
		a,b = Coeff.common ha,hb
		a.should == [4]
		b.should == [12]
	end

	it 'should return everything when the items are all ' do
		ha = { :a => 3,  :c => 4,  :a => 2}
		hb = { :b => 12, :a => 66, :c => 14 }
		a,b = Coeff.common ha,hb
		a.should == [4, 2]
		b.should == [14, 66]
	end

end

describe 'pearson coeff' do
	
	it 'should be 1 for the same data' do
		a = [2,3,7,8]
		Coeff.pearson_coeff(a,a).should be_close(1.0, 1e-3)
	end

	it 'should be 1 for the same data; grade inflated' do
		a = [2,3,7,8]
		b = [3,4,8,9]
		Coeff.pearson_coeff(a,b).should be_close(1.0, 1e-3)
	end

	it 'should be 1 for the same data; grade inflated' do
		a = [12,3,27,18]
		b = [3,14,8,29]
		Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
	end

end

