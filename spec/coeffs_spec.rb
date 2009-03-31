require 'coeffs.rb'

describe 'pearson coeff' do

    describe "when all indexes are the same" do
        it 'should be 1 for the same data' do
            a = [0,2, 1,3, 2,7, 3,8]
            Coeff.pearson_coeff(a,a).should be_close(1.0, 1e-3)
        end

        it 'should be 1 for the same data; grade inflated' do
            a = [0,2, 1,3, 2,7, 3,8]
            b = [0,3, 1,4, 2,8, 3,9]
            Coeff.pearson_coeff(a,b).should be_close(1.0, 1e-3)
        end

        it 'should be 1 for the same data; grade inflated' do
            a = [0,12, 1,3,  5,27, 7,18]
            b = [0,3,  1,14, 5,8,  7,29]
            Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
        end
    end

    describe "when all indexes are different" do
        it 'should be 0' do
            a = [0,12, 2,3,  4,27, 6,18]
            b = [1,3,  3,14, 5,8,  7,29]
            Coeff.pearson_coeff(a,b).should ==0
        end
    end

    describe "when the two lists have different indexes" do
        describe "but start with the same indexes" do
            it 'should only consider common indexes when the first has more' do
                a = [0,12, 3,3,  5,27, 6,18, 8,6]
                b = [0,3,  3,14, 5,8,  6,29]
                Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
            end
            it 'should only consider common indexes when the second has more' do
                a = [0,12, 1,3,  2,27, 3,18]
                b = [0,3,  1,14, 2,8,  3,29, 4,5]
                Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
            end
        end
        describe "but end with the same indexes" do
            it 'should only consider common indexes when the first has more' do
                a = [0,4, 1,2, 2,12, 3,3,  4,27, 5,18]
                b = [          2,3,  3,14, 4,8,  5,29]
                Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
            end
            it 'should only consider common indexes when the second has more' do
                a = [          2,12, 3,3,  4,27, 5,18]
                b = [0,3, 1,4, 2,3,  3,14, 4,8,  5,29]
                Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
            end
        end
        describe "but dont start or end with the same indexes" do
            it 'should only consider common indexes' do
                a = [0,4, 1,2, 2,12, 3,3,  4,27, 5,18]
                b = [          2,3,  3,14, 4,8,  5,29, 6,5, 7,8]
                Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
            end
            it 'should only consider common indexes' do
                a = [          2,12, 3,3,  4,27, 5,18, 8,7, 10,2]
                b = [0,3, 1,4, 2,3,  3,14, 4,8,  5,29]
                Coeff.pearson_coeff(a,b).should be_close(0.017, 1e-3)
            end
        end
    end

end

