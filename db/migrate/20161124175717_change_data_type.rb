class ChangeDataType < ActiveRecord::Migration[5.0]
  def change
  	change_column :activities, :pace, 'float USING CAST(pace AS float)'
  end
end
