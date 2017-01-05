class Activities < ActiveRecord::Base
	self.table_name= "activities"

  validates :date, presence: true
  validates :time, presence: true
  validates :duration, presence: true
  validates :distance, presence: true
  validates :weight_before, presence: true
  validates :weight_after, presence: true

  SWIMMING   = 1
  CYCLING = 2
  RUNNING = 3
  OTHER = 4

  def self.swimming(user_id, unit_name)
    results = sports_range(user_id, unit_name, SWIMMING)
    transform_results(results)
  end

  def self.cycling(user_id, unit_name)
    results = sports_range(user_id, unit_name, CYCLING)
    transform_results(results)
  end

  def self.running(user_id, unit_name)
    results = sports_range(user_id, unit_name, RUNNING)
    transform_results(results)
  end

  def self.other(user_id, unit_name)
    results = sports_range(user_id, unit_name, OTHER)
    transform_results(results)
  end

  def self.reports(user_id, activities, efforts, temp_ranges, unit_name)
    result_hash = {}
    efforts.each do |effort|
      temp_hash = {}
      temp_ranges.each do |range|
        low, high = range.split("-")
        data_fetched = reports_data(user_id, effort, activities, low, high, unit_name)
          stddev = data_fetched.try(:stddev_temp).try(:to_d).truncate(2).to_s('F') if data_fetched.try(:stddev_temp).present?
          temp_hash[range] = {
            min: data_fetched.try(:min_temp).to_f.round(2),
            max: data_fetched.try(:max_temp).to_f.round(2),
            avg: data_fetched.try(:avg_temp).to_f.round(2),
            range: data_fetched.try(:range_temp).to_f.round(2),
            count: data_fetched.try(:count_temp).to_f.round(2),
            stddev: stddev.to_f.round(2)
          }
      end
      result_hash[effort] = temp_hash
    end
    result_hash
  end

  def self.reports_count(user_id, activities, efforts, temp_ranges, unit_name)
    result_hash = {}
    efforts.each do |effort|
      temp_hash = {}
      temp_ranges.each do |range|
        low, high = range.split("-")
        data_fetched = reports_count_data(user_id, effort, activities, low, high, unit_name)
        temp_hash[range] = data_fetched.try(:count_temp).to_i
      end
      result_hash[effort] = temp_hash
    end
    result_hash
  end

  def self.graph_reports(user_id, activities, efforts, unit_name)
    results_hash = {}

    temp = "temp_feels_like"

    if (unit_name == "Impreial")
      temp = "imperial_temp_feels_like"
    end

    efforts.each do |effort|
      results_hash[effort] = Activities.select(temp + ", sweat_rate").where(activity: activities, user_id: user_id, effort: effort).to_a
    end  

    results = {}
    results['low'] = results_hash['low'].map { |p| [ p[temp].round(2) , p['sweat_rate']] }
    results['medium'] = results_hash['medium'].map { |p| [ p[temp].round(2) , p['sweat_rate']] }
    results['high'] = results_hash['high'].map { |p| [ p[temp].round(2) , p['sweat_rate']] }
    
    results
  end

  private

  def self.sports_range(user_id, unit_name, sports_id)
     result = []
    if (unit_name == "Metric")
      result << Activities.select("effort, count(*)").where("sports_id = ? and temp_feels_like < ? and user_id = ? ", sports_id, 10, user_id).group(:effort).order(:effort)
      result << Activities.select("effort, count(*)").where("sports_id = ? and temp_feels_like >= ? and temp_feels_like <= ? and user_id = ? ", sports_id, 10, 20, user_id).group(:effort).order(:effort)
      result << Activities.select("effort, count(*)").where("sports_id = ? and temp_feels_like > ? and temp_feels_like <= ? and user_id = ? ", sports_id, 20, 30, user_id).group(:effort).order(:effort)
      result << Activities.select("effort, count(*)").where("sports_id = ? and temp_feels_like > ? and user_id = ? ", sports_id, 30, user_id).group(:effort).order(:effort)
    else
      result << Activities.select("effort, count(*)").where("sports_id = ? and imperial_temp_feels_like < ? and user_id = ? ", sports_id, 50, user_id).group(:effort).order(:effort)
      result << Activities.select("effort, count(*)").where("sports_id = ? and imperial_temp_feels_like >= ? and imperial_temp_feels_like <= ? and user_id = ? ", sports_id, 50, 70, user_id).group(:effort).order(:effort)
      result << Activities.select("effort, count(*)").where("sports_id = ? and imperial_temp_feels_like > ? and imperial_temp_feels_like <= ? and user_id = ? ", sports_id, 70, 90, user_id).group(:effort).order(:effort)
      result << Activities.select("effort, count(*)").where("sports_id = ? and imperial_temp_feels_like > ? and user_id = ? ", sports_id, 90, user_id).group(:effort).order(:effort)
    end
    result
  end

  def self.transform_results results
    data = {}
    #Assuming effort data to be "low", "medium", "high" as they are string
    data["Low"] = { name: "Low",
                    less_than_fifty: results[0].select{|x| x.effort=="low"}.to_a.first.try(:count).to_i,
                    less_than_seventy: results[1].select{|x| x.effort=="low"}.to_a.first.try(:count).to_i,
                    less_than_ninety: results[2].select{|x| x.effort=="low"}.to_a.first.try(:count).to_i,
                    greater_than_ninety: results[3].select{|x| x.effort=="low"}.to_a.first.try(:count).to_i
                  }
    data["Medium"] = { 
    			name: "Medium",
                less_than_fifty: results[0].select{|x| x.effort=="medium"}.to_a.first.try(:count).to_i,
                less_than_seventy: results[1].select{|x| x.effort=="medium"}.to_a.first.try(:count).to_i,
                less_than_ninety: results[2].select{|x| x.effort=="medium"}.to_a.first.try(:count).to_i,
                greater_than_ninety: results[3].select{|x| x.effort=="medium"}.to_a.first.try(:count).to_i
              }
    data["High"] = { 
    		name: "High",
              less_than_fifty: results[0].select{|x| x.effort=="high"}.to_a.first.try(:count).to_i,
              less_than_seventy: results[1].select{|x| x.effort=="high"}.to_a.first.try(:count).to_i,
              less_than_ninety: results[2].select{|x| x.effort=="high"}.to_a.first.try(:count).to_i,
              greater_than_ninety: results[3].select{|x| x.effort=="high"}.to_a.first.try(:count).to_i
            }
    result = [data["High"], data["Medium"], data["Low"]]
  end

  def self.reports_data(user_id, effort, activities, low, high, unit_name)
    if (unit_name == "Metric")
      query_results = Activities.select("min(sweat_rate) as min_temp, max(sweat_rate) as max_temp, avg(sweat_rate) as avg_temp, max(sweat_rate)-min(sweat_rate) as range_temp, count(*) as count_temp, stddev(sweat_rate) as stddev_temp").
        where("user_id = ? and effort = ? and activity in (?) and temp_feels_like > ? and temp_feels_like <= ?", 
          user_id, effort, activities, low, high).all
    else
      query_results = Activities.select("min(sweat_rate) as min_temp, max(sweat_rate) as max_temp, avg(sweat_rate) as avg_temp, max(sweat_rate)-min(sweat_rate) as range_temp, count(*) as count_temp, stddev(sweat_rate) as stddev_temp").
        where("user_id = ? and effort = ? and activity in (?) and imperial_temp_feels_like > ? and imperial_temp_feels_like <= ?", 
          user_id, effort, activities, low, high).all
    end

    query_results[0]
  end

  def self.reports_count_data(user_id, effort, activities, low, high, unit_name)

    if (unit_name == "Metric")
      query_results = Activities.select("count(*) as count_temp").
        where("user_id = ? and effort = ? and activity in (?) and temp_feels_like > ? and temp_feels_like <= ?", 
          user_id, effort, activities, low, high).all
    else 
      query_results = Activities.select("count(*) as count_temp").
        where("user_id = ? and effort = ? and activity in (?) and imperial_temp_feels_like > ? and imperial_temp_feels_like <= ?", 
          user_id, effort, activities, low, high).all
    end

    query_results[0]
  end

end