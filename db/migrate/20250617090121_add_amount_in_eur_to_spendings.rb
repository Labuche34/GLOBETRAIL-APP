class AddAmountInEurToSpendings < ActiveRecord::Migration[7.1]
  def change
    add_column :spendings, :amount_in_eur, :decimal
  end
end
