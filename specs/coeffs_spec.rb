require 'coeffs.rb'

describe 'pearson coeff' do
	
	it 'should be 1 for the same data' do
		a = [0,2, 1,3, 2,7, 3,8]
		Coeff.pearson_coeff(a,a).should be_close(1.0, 1e-3)
	end

#	it 'should be 1 for the same data; grade inflated' do
#		a = [0,2, 1,3, 2,7, 3,8]
#		b = [0,3, 1,4, 2,8, 3,9]
#		Coeff.pearson_coeff(a,b).should be_close(1.0, 1e-3)
#	end

	it 'should be 1 for the same data; grade inflated' do
		a = [0,12, 1,3,  2,27, 3,18]
		b = [0,3,  1,14, 2,8,  3,29]
		Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
	end

end

