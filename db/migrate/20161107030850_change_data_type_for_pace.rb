class ChangeDataTypeForPace < ActiveRecord::Migration[5.0]
  def change
  	change_column :activities, :pace, :string
  end
end