class AddCalendarToTravels < ActiveRecord::Migration[7.1]
  def change
    add_column :travels, :start_date, :date
    add_column :travels, :end_date, :date
  end
end
