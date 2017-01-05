class ChangeDataTypeForSweatRate < ActiveRecord::Migration[5.0]
  def change
  	change_column :activities, :sweat_rate, 'float USING CAST(sweat_rate AS float)'
  end
end
