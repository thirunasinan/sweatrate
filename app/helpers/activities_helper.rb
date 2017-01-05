module ActivitiesHelper
	def time_format(time)
		return time.hour.to_s + ":" + time.min.to_s + ":" + time.sec.to_s
	end
end
