class Reports < ActiveRecord::Base
	self.table_name= "reports"
	self.primary_key = "id"

	 #def self.to_csv(options = {})
    # CSV.generate(options) do |csv|
    #  csv << column_names
    #  all.each do |p|
    #    csv << p.attributes.values_at(*column_names)
    #  end
    # end
  #end
end
