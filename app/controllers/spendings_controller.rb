class SpendingsController < ApplicationController
  def index
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spendings = Spending.all
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def new
    @spending = Spending.new(spending_params)
  end

  def create
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spending = Spending.new(spending_params)
    @stop.travel = @travel
    @spending.stop = @stop

    # Trouver la devise du pays
    # country = ISO3166::Country.new(@travel.country)
    country = ISO3166::Country.find_country_by_any_name(@travel.country)  # => objet country
    code = country&.alpha2                                            # => "ID", "US", "FR", etc.
    currency = country.currency_code rescue "EUR"
    @spending.currency = currency
    # Convertir le montant vers l'EUR à la date d’aujourd’hui
    original_amount = Money.from_amount(@spending.amount.to_f, currency)
    converted = Money.default_bank.exchange_with(original_amount, "EUR")
    @spending.amount_in_eur_cents = (converted.to_f) * 100

    @spending.save
    redirect_to stop_path(@stop), notice: "Spending added"
  end

  def edit
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spending = Spending.find(params[:id])
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def update
    @travel = Travel.find(params[:travel_id])
    @stop = Stop.find(params[:stop_id])
    @spending = Spending.find(params[:id])
    if @spending.update(spending_params)
      redirect_to stop_path(@stop)
    else
      render :edit, status: :unprocessable_entity
    end
    # sera sur la page visualisation de figma avec spendings et notes
  end

  def destroy
    @spending = Spending.find(params[:id])
    @spending.destroy
    redirect_to stop_path(@spending.stop), status: :see_other
    # sera sur la page visualisation de figma avec spendings et notes
  end

  private

  def spending_params
    params.require(:spending).permit(:category, :amount_cents, :currency)
  end
end
