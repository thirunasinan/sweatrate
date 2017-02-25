class CreateImpactivities < ActiveRecord::Migration[5.0]
  def change
    create_table :impactivities do |t|
      t.integer :user_id,       :null => false
      t.integer :sports_id,     :null => false
      t.integer :activity,      :null => false
      t.string  :description
      t.date    :date
      t.time    :time
      t.time    :duration
      t.float   :distance,      :default => 0
      t.string  :effort
      t.float   :speed,         :default => 0
      t.float :pace,          :default => 0
      t.integer :average_power, :default => 0
      t.integer :weighted_average_power
      t.integer :normalized_power
      t.integer :average_heart_rate
      t.integer :training_stress_score
      t.integer :elevation_loss
      t.integer :elevation_gain
      t.float :temp_feels_like    
      t.float :hydration
      t.float :weight_before
      t.float :weight_after
      t.string  :notes
      t.integer :food
      t.integer :urination_actual_time
      t.integer :urination
      t.string  :bowel_sizing
      t.integer :bowel_movement
      t.integer :humidity
      t.integer :wind
      t.string  :clouds
      t.integer :temp
      t.float :sweat_rate
      t.float :imperial_temp_feels_like
      t.float :imperial_sweat_rate
      t.boolean :is_include, :default =>true


    end
  end
end
