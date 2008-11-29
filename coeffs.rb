require 'set'

module Coeff

	def self.common ha, hb
		common_keys = Set.new(ha.keys).intersection Set.new(hb.keys)
		puts "common_keys = #{common_keys.inspect}"
		a=[]; b=[]
		common_keys.each do |k| 
			a << ha[k]
			b << hb[k]
		end
		[a, b]
	end

	def self.pearson_coeff a, b
		raise [a.size,b.size] unless a.size == b.size
		return 0 if a.empty?

		sum_a = a.inject(0) { |s,v| s += v }.to_f
		sum_b = b.inject(0) { |s,v| s += v }.to_f
		sum_a_sq = a.inject(0) { |s,v| s += v*v }.to_f
		sum_b_sq = b.inject(0) { |s,v| s += v*v }.to_f

		n = a.size
		pa = sum_a_sq - (sum_a * sum_a / n)
		pb = sum_b_sq - (sum_b * sum_b / n)
		denominator = Math.sqrt(pa * pb)
		return 0 if	denominator == 0

		product_sum = a.zip(b).inject(0) { |s,v| s += v[0] * v[1] }.to_f
		numerator = product_sum - (sum_a * sum_b / n)
		numerator / denominator
	end

end
