class Spending < ApplicationRecord
  belongs_to :stop
  monetize :amount_cents   # => accessible via .amount
  monetize :amount_in_eur_cents, as: "amount_in_eur", with_currency: :eur
end
