class AddColumnInActivities < ActiveRecord::Migration[5.0]
  def change
  	add_column :activities, :imperial_temp_feels_like, :float
  	add_column :activities, :imperial_sweat_rate, :float
  end
end
