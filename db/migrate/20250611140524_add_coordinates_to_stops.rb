class AddCoordinatesToStops < ActiveRecord::Migration[7.1]
  def change
    add_column :stops, :latitude, :float
    add_column :stops, :longitude, :float
  end
end
