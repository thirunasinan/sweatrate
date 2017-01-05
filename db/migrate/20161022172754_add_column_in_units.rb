class AddColumnInUnits < ActiveRecord::Migration[5.0]
  def change
  	add_column :units, :swimming_pace, :string
  end
end
