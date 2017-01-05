class AddUnitsTypeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unit_type, :integer
  end
end
