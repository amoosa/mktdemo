class ChangeDefaultShipping < ActiveRecord::Migration
  def change
  	change_column_default(:orders, :tracking, nil)
  	change_column_default(:orders, :carrier, nil)
  end
end
