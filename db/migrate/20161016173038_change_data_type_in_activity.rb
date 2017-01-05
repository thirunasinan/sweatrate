class ChangeDataTypeInActivity < ActiveRecord::Migration[5.0]
  def change
  	change_column :activities, :hydration, 'float USING CAST(hydration AS float)'
  	change_column :activities, :pace, 'float USING CAST(pace AS float)'
  end
end
