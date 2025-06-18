class AddColumnToTravel < ActiveRecord::Migration[7.1]
  def change
    add_column :travels, :latitude, :float
    add_column :travels, :longitude, :float
  end
end
