require 'mysql'

class Db

    def initialize
        @db = Mysql.init()
        @db.connect('localhost')
        @db.select_db('netflix')
    end

    def set_similarity mid1, mid2, similiarity
        mid1, mid2 = mid2, mid1 if mid1 > mid2
        @db.query_with_result = false
        query = "insert into similarities (mid1,mid2,similarity) values (#{mid1},#{mid2},#{similiarity});"
        #puts "Q #{query}"
        @db.query(query)
    end

    def get_similarity mid1, mid2
        mid1, mid2 = mid2, mid1 if mid1 > mid2
        @db.query_with_result = true
        query = "select similarity from similarities where mid1=#{mid1} and mid2=#{mid2}"
        res = @db.query(query)
        row = res.fetch_row
        similarity = row.first.to_f
        res.free
        similarity
    end

#    def close
#        @db.close()
#    end

end

DB = Db.new
