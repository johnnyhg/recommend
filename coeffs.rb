
module Coeff

	def self.pearson_coeff a, b
		raise [a.size,b.size] unless a.size == b.size
		return 0 if a.empty?

        n = a.size-1
        a_idx = b_idx = 0
        a_uid, b_uid = a[a_idx], b[b_idx]

        sum_a = sum_b = sum_a_sq = sum_b_sq = product_sum = 0.to_f

        continue = true
        while continue do
            puts "a_idx=#{a_idx} b_idx=#{b_idx}"
            if a_uid == b_uid
                a_rating = a[a_idx+1]
                b_rating = b[b_idx+1]
                sum_a += a_rating
                sum_b += b_rating
                sum_a_sq += a_rating * a_rating
                sum_b_sq += b_rating * b_rating
                product_sum += a_rating * b_rating
                a_idx += 2
                b_idx += 2
                a_uid, b_uid = a[a_idx], b[b_idx]
                continue = a_idx <= n
            elsif a_uid < b_uid
                a_idx += 2
                a_uid = a[a_idx]
                continue = a_idx <= n
            else # b_uid < a_uid
                b_idx += 2
                b_uid = b[b_idx]
                continue = b_idx <= n
            end
        end

        puts "sum_a=#{sum_a} sum_b=#{sum_b} sum_a_sq=#{sum_a_sq} sum_b_sq=#{sum_b_sq} product_sum=#{product_sum}"

		n = a.size
		pa = sum_a_sq - (sum_a * sum_a / n)
		pb = sum_b_sq - (sum_b * sum_b / n)
		denominator = Math.sqrt(pa * pb)
		return 0 if	denominator == 0

		numerator = product_sum - (sum_a * sum_b / n)
		numerator / denominator
	end

end
