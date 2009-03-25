class Db

	def initialize
		require 'mysql'
		@db = Mysql.init()
		@db.connect('localhost')
		@db.select_db('netflix')
	end

	def update mid1, mid2, similiarity
		raise "called with mid1 = mid2 = #{mid1} ??" if mid1==mid2
		mid1, mid2 = mid2, mid1 if mid1 > mid2
		query = "insert into similarity (mid1,mid2,coeff) values (#{mid1},#{mid2},#{similiarity});"
		#puts "Q #{query}"
		#@db.query(query)
	end

	def close
		@db.close()
	end

end
