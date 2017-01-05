class ChangeDataTypeForUnitsInUser < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :unit_type, :integer, :default => 1
  end
end
