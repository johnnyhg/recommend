module Coeff

    # a,b = [idx,rating, idx,rating, idx,rating]
    # idxes are sorted
    def self.pearson_coeff a, b
        return 0 if a.empty?

        a_idx = b_idx = 0
        a_uid, b_uid = a[a_idx], b[b_idx]

        sum_a = sum_b = sum_a_sq = sum_b_sq = product_sum = 0.to_f

        num_common = 0
        continue = true
        while continue do
            if a_uid == b_uid
                # indexes match, this pair should contribute
                a_rating = a[a_idx+1]
                b_rating = b[b_idx+1]
                sum_a += a_rating
                sum_b += b_rating
                sum_a_sq += a_rating * a_rating
                sum_b_sq += b_rating * b_rating
                product_sum += a_rating * b_rating
                a_idx += 2
                b_idx += 2
                num_common += 1
                a_uid, b_uid = a[a_idx], b[b_idx]
                continue = a_idx < a.size && b_idx < b.size
            elsif a_uid < b_uid
                # 'pop' entry from a list
                a_idx += 2
                a_uid = a[a_idx]
                continue = a_idx < a.size
            else # b_uid < a_uid
                # 'pop' entry from b list
                b_idx += 2
                b_uid = b[b_idx]
                continue = b_idx < b.size
            end
        end

        return 0 if num_common == 0

        pa = sum_a_sq - (sum_a * sum_a / num_common)
        pb = sum_b_sq - (sum_b * sum_b / num_common)
        denominator = Math.sqrt(pa * pb)

        return 0 if	denominator == 0

        numerator = product_sum - (sum_a * sum_b / num_common)
        numerator / denominator
    end

end
