class RenameColumnsInTravels < ActiveRecord::Migration[7.1]
  def change
    rename_column :travels, :start_date, :departure_date
    rename_column :travels, :end_date, :return_date
  end
end
