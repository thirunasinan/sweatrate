class ActivitiesController < ApplicationController
	before_filter :units, :only => [ :index, :new, :edit, :swimming, :cycling, :running, :other, :reports_analysis]
	before_filter :set_report_selected_tab, :only => [:reports_table, :reports_coverage, :reports_analysis]
	before_filter :set_dashboard_selected_tab, :only => [:swimming, :cycling, :running]



	def units
		@units = current_user.units.to_json
	end

	def index

		@selected_tab = :all_activity

		@sports = Sports.all.to_json
		@activities = Activities.where(user_id: current_user.id).to_json
     
		unit_name = current_user.units.first.name
		if(unit_name != "Impreial")	
		 @activity= Reports.where(user_id: current_user.id)	
		  csv_string = CSV.generate do |csv|
         csv << ["S.No", "Include", "Date (yyyy-mm-dd)","Time (hh:mm:ss)","Sport","Distance (km)","Speed (kph)",
         	    "Pace (min/km / min/100m)","Duration (hh:mm:ss)","Effort","Temp Feels Like (oC)" ,"Weight Before (kg)" ,"Weight After (kg)","Hydration (L)",
         	    "Sweat Rate (L/hr)","Description","Notes"]
         @activity.each.with_index do |a,index|
         	
           csv << [index + 1  ,a.is_include, a.date, (a.time).strftime("%H : %M :%S"), a.sport, a.distance,a.speed ,a.pace ,(a.duration).strftime("%H : %M :%S") ,a.effort,a.temp_feels_like ,a.weight_before ,a.weight_after,
			a.hydration ,a.sweat_rate ,a.description ,a.notes]
			
         end
    end         
 		
		respond_to do |format|
			format.html
      		format.csv { send_data  csv_string,:type => 'text/csv; charset=iso-8859-1; header=present',
   						:disposition => "attachment;",filename: "Activities(Metric)-#{DateTime.now.to_s}.csv"}

   			format.xls { send_data  csv_string,:type => 'text/xls; charset=iso-8859-1; header=present',
   						:disposition => "attachment;",filename: "Activities(Metric)-#{DateTime.now.to_s}.xls"}

      		
  			end

  		else
  		 @impactivity= Impreports.where(user_id: current_user.id)	
		  csv_string = CSV.generate do |csv|
         csv << ["S.No", "Include", "Date (yyyy-mm-dd)","Time (hh:mm:ss)","Sport","Distance (mi)","Speed (mph)",
         	    "Pace (min/mi / min/100yd)","Duration (hh:mm:ss)","Effort","Temp Feels Like (oF)" ,"Weight Before (lbs)" ,"Weight After (lbs)","Hydration (fl oz)",
         	    "Sweat Rate (L/hr)","Description","Notes"]
         @impactivity.each.with_index do |a,index|
         	
           csv << [index + 1  ,a.is_include, a.date, (a.time).strftime("%H : %M :%S"), a.sport, a.distance,a.speed ,a.pace ,(a.duration).strftime("%H : %M :%S") ,a.effort,a.temp_feels_like ,a.weight_before ,a.weight_after,
			a.hydration ,a.sweat_rate ,a.description ,a.notes]
			
         end
    end         
 		
		respond_to do |format|
			format.html
      		format.csv { send_data  csv_string,:type => 'text/csv; charset=iso-8859-1; header=present',
   						:disposition => "attachment;",filename: "Activities(Imperial)-#{DateTime.now.to_s}.csv"}

   			format.xls { send_data  csv_string,:type => 'text/xls; charset=iso-8859-1; header=present',
   						:disposition => "attachment;",filename: "Activities(Imperial)-#{DateTime.now.to_s}.xls"}

      		
  			end

  		end


	end

	def isinclude 
			isChecked = params[:is_include]
			id = params[:id]		
			
			if Activities.where(:id => id).update_all(is_include: isChecked)
				Impactivities.where(:id => id).update_all(is_include: isChecked)
				@selected_tab = :all_activity
				@sports = Sports.all.to_json
				@activities = Activities.where(user_id: current_user.id).to_json

				respond_to do | format|
					format.html{render "index" }
				end
			else
					redirect_to :back
			end

			
		end

	def new
		@selected_tab = :sweat_rate_calc

		@widgets = current_user.widget_config
		@activities = Activities.new
		@sports = Sports.all.to_json
	end

	def create
		
		
		# For Imperial calc
		@temp_feels_like = temp_for_imperial
		# @sweat_rate = 0

		convert_impreial_to_metric
		params[:sweat_rate] = calc_sweatrate

		

		time_calc_duration
		# time_calc_pace


		@activities = Activities.new(activity_params)
		@activities.user_id = current_user.id
		@activities.sports_id = @activities.activity

		@activities.imperial_temp_feels_like = @temp_feels_like

		unit_name = current_user.units.first.name
		if(unit_name != "Impreial")				
				if(params["activity"].to_i == 2 || params["activity"].to_i == 4)
					@imp_speed = (params["speed"].to_f * 0.621371).round(5)
				else
					if(params["activity"].to_i == 1)
						@imp_pace = (params["pace"].to_f * 0.9144).round(5)
					else
						@imp_pace  = (params["pace"].to_f * 1.60934).round(5)
					end
				end

				@imp_temp_feels_like = ((params["temp_feels_like"].to_f * 9/5) + 32 ).round(5)
				@imp_distance  = (params["distance"].to_f * 0.621371).round(6)
				@imp_weight_before = (params["weight_before"].to_f * 2.20462).round(5)
				@imp_weight_after = (params["weight_after"].to_f * 2.20462).round(5)
				@imp_hydration = (params["hydration"].to_f * 33.814).round(5)
			else
				if(params["activity"].to_i == 2 || params["activity"].to_i == 4)
					@imp_speed = (params["speed"].to_f / 0.621371).round(5)
				else
					if(params["activity"].to_i == 1)
						@imp_pace = (params["pace"].to_f / 0.9144).round(5)
					else
						@imp_pace = (params["pace"].to_f / 1.60934).round(5)
					end
				end

				@imp_temp_feels_like = ((params["temp_feels_like"].to_f - 32) * 5/9).round(5)
				@imp_distance  = (params["distance"].to_f / 0.621371).round(6)
				@imp_weight_before = (params["weight_before"].to_f / 2.20462).round(5)
				@imp_weight_after = (params["weight_after"].to_f / 2.20462).round(5)
				@imp_hydration = (params["hydration"].to_f / 33.814).round(5)
			end


		@impactivities = Impactivities.new()
		@impactivities.activity = @activities.activity
		@impactivities.user_id = current_user.id
		@impactivities.sports_id = @activities.activity
		@impactivities.description = @activities.description
		@impactivities.date = @activities.date
		@impactivities.time =@activities.time
		@impactivities.duration =@activities.duration
		@impactivities.distance = @imp_distance
		@impactivities.effort = @activities.effort
		@impactivities.speed = (@imp_speed != nil ) ? @imp_speed : 0
		@impactivities.pace =(@imp_pace != nil ) ? @imp_pace : 0
		@impactivities.temp_feels_like =@imp_temp_feels_like
		@impactivities.weight_after = @imp_weight_after
		@impactivities.weight_before = @imp_weight_before
		@impactivities.hydration = @imp_hydration
		@impactivities.imperial_temp_feels_like = @imp_temp_feels_like
		@impactivities.notes = @activities.notes
		@impactivities.sweat_rate = @activities.sweat_rate



		if calc_sweatrate > 3.0
			redirect_to :back, warning: "You have entered weights and hydration that suggests sweat rate over 3 L/hr.  This is well beyond normal sweat rates.  Please recheck your inputs."
		else
		if @activities.save
			@impactivities.id = @activities.id
			@impactivities.save
			redirect_to edit_activity_path(@activities), notice: "Activity created successful"
		else 
		 redirect_to :back, warning: @activities.errors 
		end
	end

	end

	def update
		# For Imperial calc
		@temp_feels_like = temp_for_imperial

		convert_impreial_to_metric
		params[:sweat_rate] = calc_sweatrate

		time_calc_duration
		# time_calc_pace

		@activities = Activities.find(params[:id])
		@activities.sports_id = @activities.activity

		@activities.imperial_temp_feels_like = @temp_feels_like

		unit_name = current_user.units.first.name
		if(unit_name != "Impreial")				
				if(params["activity"].to_i == 2 || params["activity"].to_i == 4)
					@imp_speed = (params["speed"].to_f * 0.621371).round(5)
				else
					if(params["activity"].to_i == 1)
						@imp_pace = (params["pace"].to_f * 0.9144).round(5)
					else
						@imp_pace  = (params["pace"].to_f * 1.60934).round(5)
					end
				end

				@imp_temp_feels_like = ((params["temp_feels_like"].to_f * 9/5) + 32 ).round(5)
				@imp_distance  = (params["distance"].to_f * 0.621371).round(6)
				@imp_weight_before = (params["weight_before"].to_f * 2.20462).round(5)
				@imp_weight_after = (params["weight_after"].to_f * 2.20462).round(5)
				@imp_hydration = (params["hydration"].to_f * 33.814).round(5)
			else
				if(params["activity"].to_i == 2 || params["activity"].to_i == 4)
					@imp_speed = (params["speed"].to_f / 0.621371).round(5)
				else
					if(params["activity"].to_i == 1)
						@imp_pace = (params["pace"].to_f / 0.9144).round(5)
					else
						@imp_pace = (params["pace"].to_f / 1.60934).round(5)
					end
				end

				@imp_temp_feels_like = ((params["temp_feels_like"].to_f - 32) * 5/9).round(5)
				@imp_distance  = (params["distance"].to_f / 0.621371).round(6)
				@imp_weight_before = (params["weight_before"].to_f / 2.20462).round(5)
				@imp_weight_after = (params["weight_after"].to_f / 2.20462).round(5)
				@imp_hydration = (params["hydration"].to_f / 33.814).round(5)
			end



		@impactivities = Impactivities.find(params[:id])

		@impactivities.activity = @activities.activity
		@impactivities.user_id = current_user.id
		@impactivities.sports_id = @activities.activity
		@impactivities.description = @activities.description
		@impactivities.date = @activities.date
		@impactivities.time =@activities.time
		@impactivities.duration =@activities.duration
		@impactivities.distance = @imp_distance
		@impactivities.effort = @activities.effort
		@impactivities.speed = (@imp_speed != nil ) ? @imp_speed : 0
		@impactivities.pace = (@imp_pace != nil ) ? @imp_pace : 0
		@impactivities.temp_feels_like =@imp_temp_feels_like
		@impactivities.weight_after = @imp_weight_after
		@impactivities.weight_before = @imp_weight_before
		@impactivities.hydration = @imp_hydration
		@impactivities.imperial_temp_feels_like = @imp_temp_feels_like
		@impactivities.notes = @activities.notes
		@impactivities.sweat_rate = @activities.sweat_rate




		if calc_sweatrate > 3.0
			redirect_to :back, warning: "You have entered weights and hydration that suggests sweat rate over 3 L/hr.  This is well beyond normal sweat rates.  Please recheck your inputs."
	
		else
		if @activities.update(activity_params)
			

			if params[:submit] == "Save"
				@impactivities.update(impactivity_params)
				redirect_to activities_path, notice: "Activity update saved successful"
			
			else
				redirect_to edit_activity_path(@activities), notice: "Activity updated successful"
			end
		else
			redirect_to :back ,warning: @activities.errors
		end
	end
	
end


	def swimming
		@sports = Sports.all.to_json
		@activities = fetch_data(Activities::SWIMMING)
		render "index"
	end

	def cycling
		@sports = Sports.all.to_json
		@activities = fetch_data(Activities::CYCLING)
		render "index"
	end

	def running
		@sports = Sports.all.to_json
		@activities = fetch_data(Activities::RUNNING)
		render "index"
	end

	def other
		@sports = Sports.all.to_json
		@activities = fetch_data(Activities::OTHER)
		render "index"
	end

	def edit
		@selected_tab = :sweat_rate_calc

		activities = Activities.find(params[:id])
# 		time = activities[:time]
# 		duration = activities[:duration]

# 		activities[:time] = time.hour.to_s + ":" + time.min.to_s + ":" + time.sec.to_s
# 		activities[:duration] = duration.hour.to_s + ":" + duration.min.to_s + ":" + duration.sec.to_s
# debugger
		@activities = activities
		@sports = Sports.all.to_json
	end

	def reports_table

		activities = params[:activities] || [1,2,3,4]
		intensities = params[:intensities] || ["low", "medium", "high"]

		@unit_name = current_user.units.first.name

		temp_r = ["0-10" ,"10-20", "20-30" ,"30-40", "40-50", "50-60"]

		if(@unit_name == "Impreial")
			temp_r = ["40-50", "50-60", "60-70", "70-80", "80-90", "90-100"]
		end

		temp_range = params[:temp_range] || temp_r

		data = []
		data << Activities.reports_count(current_user.id, activities, intensities, temp_range, @unit_name)

		@reports_table = data.to_json

		respond_to do |format|
      format.html { render "reports/reports_table"  }
      format.json { render :json => { :reports_table => data }.to_json }
    end
	end

	def reports_coverage

		activities = params[:activities] || [1,2,3,4]
		intensities = params[:intensities] || ["low", "medium", "high"]

		@unit_name = current_user.units.first.name

		temp_r = ["0-10" ,"10-20", "20-30" ,"30-40", "40-50", "50-60"]

		if(@unit_name == "Impreial")
			temp_r = ["40-50", "50-60", "60-70", "70-80", "80-90", "90-100"]
		end

		temp_range = params[:temp_range] || temp_r

		data = []
		data << Activities.reports(current_user.id, activities, intensities, temp_range, @unit_name)
		@reports_coverage = data.to_json

		respond_to do |format|
      format.html { render "reports/reports_coverage"  }
      format.json { render :json => { :reports_coverage => data }.to_json }
    end

	end

	def reports_analysis
		@selected_tab = :sweat_rate_analysis

		@used_sports = current_user.activities.pluck(:sports_id).sort.uniq

		# activities = params[:activities] || []
		# intensities = params[:intensities] || []
		#Assumed params
		activities = params[:activities] || @used_sports.first
		intensities = ["low", "medium", "high"]

		units = JSON.parse @units
		unit_name = units.first['name']

		@reports_analysis = Activities.graph_reports(current_user.id, activities, intensities, unit_name).to_json

		respond_to do |format|
      format.html { render "reports/reports_analysis"  }
      format.json { render :json => { :reports_analysis => @reports_analysis }.to_json }
    end
	end

	def set_report_selected_tab
		@selected_tab = :reports
	end

	def set_dashboard_selected_tab
		@selected_tab = :dashboard
	end

	private
		def activity_params
			params.permit(:activity,:description,:date,:time,:duration,:distance,:effort,:speed,:pace,:average_power,:average_heart_rate, :training_stress_score, :elevation_loss, :elevation_gain, :temp_feels_like, :hydration, :weight_before, :weight_after, :notes, :food, :urination_actual_time, :urination, :bowel_sizing, :bowel_movement, :humidity, :wind, :clouds, :temp, :sweat_rate)
		end

		def impactivity_params
			params.permit(:activity,:description,:date,:time,:duration,:distance,:effort,:speed,:pace,:average_power,:average_heart_rate, :training_stress_score, :elevation_loss, :elevation_gain, :temp_feels_like, :hydration, :weight_before, :weight_after, :notes, :food, :urination_actual_time, :urination, :bowel_sizing, :bowel_movement, :humidity, :wind, :clouds, :temp, :sweat_rate,:is_include)
		end

  
		def fetch_data sports_id
			Activities.where(user_id: current_user.id, :sports_id => sports_id).all.to_json
		end

		def calc_sweatrate
			delta = params[:weight_before].to_f - params[:weight_after].to_f
			duration = params[:duration]

			hour = ((duration.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b}).to_f / 3600)
			sweat_rate = 0

			unless hour == 0
				sweat_rate = (delta + params[:hydration].to_f) / hour
			end

			sweat_rate.round(2)
		end

		def convert_impreial_to_metric
			unit_name = current_user.units.first.name

			if (unit_name == "Impreial")
				if(params["activity"].to_i == 2 || params["activity"].to_i == 4)
					params["speed"] = (params["speed"].to_f / 0.621371).round(5)
				else
					if(params["activity"].to_i == 1)
						params["pace"] = (params["pace"].to_f / 0.9144).round(5)
					else
						params["pace"] = (params["pace"].to_f / 1.60934).round(5)
					end
				end

				params["temp_feels_like"] = ((params["temp_feels_like"].to_f - 32) * 5/9).round(5)
				params["distance"]  = (params["distance"].to_f / 0.621371).round(6)
				params["weight_before"] = (params["weight_before"].to_f / 2.20462).round(5)
				params["weight_after"] = (params["weight_after"].to_f / 2.20462).round(5)
				params["hydration"] = (params["hydration"].to_f / 33.814).round(5)
			end

	  	end

	  	def temp_for_imperial
	  		unit_name = current_user.units.first.name
	  		temp = params["temp_feels_like"].to_f

	  		if (unit_name != "Impreial")
	  			temp = ((temp * 9/5) + 32).round(5)
	  		end

	  		temp
	  	end

	  	def time_calc_duration
	  		distance = params["duration"]
	  		hh_mm_ss = distance.split(":")

	  		mm_ss = convert_sec_to_min(hh_mm_ss[2])
	  		hh_mm = convert_sec_to_min(hh_mm_ss[1].to_i + mm_ss[0])

	  	    params["duration"] = "#{pad(hh_mm_ss[0].to_i + hh_mm[0])}:#{pad(hh_mm[1])}:#{pad(mm_ss[1])}"
	  	end

	  	# def time_calc_pace
	  	# 	if(params["activity"].to_i == 1 || params["activity"].to_i == 3)
		  # 		pace = params["pace"]
		  # 		min_and_sec = pace.split(":")

		  # 		mm_ss = convert_sec_to_min(min_and_sec[1])

		  # 		params["pace"] = "#{pad(min_and_sec[0].to_i + mm_ss[0] )}:#{pad( mm_ss[1] )}"
		  # 	end
	  	# end

	  	def convert_sec_to_min min_sec
	  		mm_ss = []
  			mm_ss << (min_sec.to_i / 60).floor
  			mm_ss << (min_sec.to_i) % 60
	  	end

	  	def pad(n)
		    return (n < 10) ? ("0" + n.to_s) : n.to_s;
		end
		

end
