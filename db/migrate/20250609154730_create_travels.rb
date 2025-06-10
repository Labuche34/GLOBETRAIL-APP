class CreateTravels < ActiveRecord::Migration[7.1]
  def change
    create_table :travels do |t|
      t.string :country
      t.integer :number_of_travellers
      t.float :budget
      t.integer :trip_duration
      t.string :departure_city
      t.string :travellers_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
