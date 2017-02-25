class AddIsIncludeToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :is_include, :boolean,:default =>true
  end
end
