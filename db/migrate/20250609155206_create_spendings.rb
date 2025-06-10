class CreateSpendings < ActiveRecord::Migration[7.1]
  def change
    create_table :spendings do |t|
      t.string :category
      t.decimal :amount
      t.string :currency
      t.references :stop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
