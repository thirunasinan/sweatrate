class AddWidgetConfigColumnInUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :widget_config, :integer, :array => true, :default => [2,3]
  end
end
