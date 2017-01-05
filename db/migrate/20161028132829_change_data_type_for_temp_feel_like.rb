class ChangeDataTypeForTempFeelLike < ActiveRecord::Migration[5.0]
  def change
  	change_column :activities, :temp_feels_like, 'float USING CAST(temp_feels_like AS float)'
  end
end
