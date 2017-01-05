class ChangeDataTypeForAnotherTwo < ActiveRecord::Migration[5.0]
  def change
  	change_column :activities, :weight_before, 'float USING CAST(sweat_rate AS float)'
  	change_column :activities, :weight_after, 'float USING CAST(sweat_rate AS float)'
  end
end
