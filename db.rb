require 'mysql'

class Db

    def initialize
        @db = Mysql.init()
        @db.connect('localhost')
        @db.select_db('netflix')
    end

    def update mid1, mid2, similiarity
       @db.query_with_result = false
        raise "called with mid1 = mid2 = #{mid1} ??" if mid1==mid2
        mid1, mid2 = mid2, mid1 if mid1 > mid2
        query = "insert into similarity (mid1,mid2,coeff) values (#{mid1},#{mid2},#{similiarity});"
        #puts "Q #{query}"
        @db.query(query)
    end

    def has_done_run_for? mid
        @db.query_with_result = true
        res = @db.query("select mid from completed_runs where mid=#{mid}")
        has_done = res.num_rows > 0
        res.free
        has_done
    end

    def finished_run_for mid
        @db.query_with_result = false
        query = "insert into completed_runs (mid) values (#{mid})"
        @db.query(query)
    end

    def close
        @db.close()
    end

end
