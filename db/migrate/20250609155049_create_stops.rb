class CreateStops < ActiveRecord::Migration[7.1]
  def change
    create_table :stops do |t|
      t.string :notes
      t.string :address
      t.references :travel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
