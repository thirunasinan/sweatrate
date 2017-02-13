class Sports < ActiveRecord::Base

	self.table_name= "sports"	

	has_many :activities
end