class DefaultShipping < ActiveRecord::Migration
  def change
  	change_column_default(:orders, :tracking, 'None yet')
  	change_column_default(:orders, :carrier, 'None yet')
  end
end
