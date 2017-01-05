class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string  :name
      t.string  :distance
      t.string  :power
      t.string  :average_heart_rate
      t.string  :pace
      t.string  :speed
      t.string  :elevation_gain
      t.string  :elevation_loss
      t.string  :weight
      t.string  :temp
      t.string  :humidity
      t.string  :wind
      t.string  :temp_feels_like
      t.string  :hydration
      t.string  :food
      t.string  :urination_actual_time
      t.string  :urination
      t.string  :bowel_movement
      t.string  :sweat_rate
      
    end
  end
end
