class RenameAmountFieldsInSpendings < ActiveRecord::Migration[7.1]
  def change
    rename_column :spendings, :amount, :amount_cents
    rename_column :spendings, :amount_in_eur, :amount_in_eur_cents
  end
end
