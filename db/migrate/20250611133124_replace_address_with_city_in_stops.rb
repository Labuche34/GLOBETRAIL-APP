class ReplaceAddressWithCityInStops < ActiveRecord::Migration[7.1]
  def change
    rename_column :stops, :address, :city
  end
end
