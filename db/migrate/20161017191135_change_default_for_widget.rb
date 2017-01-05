class ChangeDefaultForWidget < ActiveRecord::Migration[5.0]
	def change
		change_column :users, :widget_config, :integer, :array => true, :default => [2,3]
	end
end
