class ChangeColumnDefaultForPace < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :activities, :pace, 0
  end
end
