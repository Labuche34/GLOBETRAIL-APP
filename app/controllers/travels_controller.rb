class TravelsController < ApplicationController
  def index
    @travels = Travel.all
  end

  def new
    @travel = Travel.new
  end

  def create
    @travel = Travel.new(travel_params)
    @travel.user = current_user
    if @travel.save
      redirect_to travel_path(@travel)
    else
      puts "Wrong entries, your travel hasn't been created"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @travel = Travel.find(params[:id])
    @stop = Stop.new
    # longitude et la latitude de chaque stop dans un travel donné

    @markers = @travel.stops.geocoded.map do |stop|
      {
        lat: stop.latitude,
        lng: stop.longitude
      }
    end
  end

  def edit
    @travel = Travel.find(params[:id])
  end

  def update
    @travel = Travel.find(params[:id])
    if @travel.update(travel_params)
      redirect_to travel_path(@travel)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @travel = Travel.find(params[:id])
    @travel.destroy
    redirect_to travels_path
  end

  def destroy_exploreo
    @travel = Travel.find(params[:id])
    @travel.destroy
    redirect_to new_exploreo_path
  end

  SYSTEM_PROMPT = <<~PROMPT
    You are a travel planner who creates highly-personalised travel itineraries.

    - ROLE
    - Destination expert
    - Booking assistant

    - TASK
    1. Utilise les préférences du voyageur pour construire un itinéraire détaillé, jour par jour, dans un style narratif, immersif et inspirant.
    2. Pour chaque jour et chaque stop (ville ou lieu principal) :
    3. Termine par un résumé du séjour (≤ 200 mots), en français sauf demande contraire, sous un titre "Résumé de votre séjour".
    4. Ajoute à la fin une phrase d’ouverture à la personnalisation (ex : "Si vous souhaitez que je personnalise cet itinéraire selon votre durée, votre budget ou d’autres préférences, n'hésitez pas à me le préciser !").
    5. Les liens doivent être réels et accessibles (pas de liens fictifs ou génériques).

    - OUTPUT FORMAT
    AUCUN caratères spéciaux dans le ra réponse itinéraire !!
    Réponds **uniquement** avec un _tableau JSON_ contenant deux éléments :
    0 → une chaîne Markdown structurée comme dans l’exemple ci-dessous, avec :
    EXEMPLE D’AFFICHAGE ATTENDU :
    "
    Itinéraire Ski à Chamonix : Jour par Jour

    Jour 1 : Arrivée et installation
    Arrivée à Chamonix, installation dans votre hébergement (hôtel, location ou refuge).
    Balade dans le centre-ville, découverte des boutiques et cafés.
    Dîner dans un restaurant typique savoyard.
    Suggestions d'hébergements :
    - Hôtel Le Morgane : https://www.lemorgane-chamonix.com
    - Les Granges d’en Haut : https://www.lesgrangesdenhaut.com
    - Chamonix Lodge : https://www.chamonixlodge.com

    Jour 2 : Premiers pas sur les pistes
    Petit-déjeuner copieux.
    Achat ou location du matériel de ski (si ce n’est pas déjà fait).
    Profitez du domaine skiable de Brévent et Flégère pour débuter en douceur.
    Déjeuner au sommet avec vue panoramique.
    Après-midi : ski libre ou initiation pour débutants.
    Liens pour les forfaits et locations :
    - Forfaits de ski Chamonix : https://www.chamonix.com/forfaits
    - Location de matériel : https://www.skiset.com/station/chamonix

    (etc.)

    Résumé de votre séjour :
    Vous passerez 4 à 5 jours à Chamonix, mêlant ski pour tous niveaux, découvertes panoramiques, activités hors-piste, et détente. Vous profiterez d’un cadre exceptionnel entre montagnes majestueuses, activités variées et gastronomie savoyarde. Ce séjour sera parfait pour vivre une expérience de ski authentique et mémorable !
    "

    1 → un objet JSON respectant exactement ce schéma :
        {
          "country": "<string>",
          "stops":
            {
              "city": "<string>",
              "city": "<string>",
              "city": "<string>",
            }
        }

        Le premier caractère de ta réponse doit être "[" et le dernier "]"

    - RULES
    * Le premier caractère de ta réponse doit être "[" et le dernier "]" ; **aucun** texte hors du tableau.
    * Les clés sont toujours entre guillemets doubles et le JSON doit être valide.
    * Utilise des dates ISO-8601.
    * Fournis de vraies URLs accessibles.
    * Entoure moi les 2 parties générées par le titre "Markdown" pour 0 et "JSON" pour 1.

      PROMPT

  def new_exploreo
    if params[:id]
      @chat = Chat.find(params[:id])
      @assistant_messages = @chat.messages.where(role: "assistant")
    else
      @assistant_messages = []
    end
  end

  def create_exploreo
    @chat = Chat.new(title: "Untitled", model_id: "gpt-4.1-nano")
    @chat.user = current_user
    @travel = Travel.create(user: current_user, country: "France")
    @chat.travel = @travel
    @chat.save
    @message = Message.new(role: "user", chat: @chat, content: params[:user_input])
    if @message.save
      build_conversation_history
      @response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      @response = JSON.parse(@response.content)
      response_as_text = @response[0]
      response_as_json = @response[1]
      create_stops_from_json(response_as_json)
      Message.create(role: "assistant", content: response_as_text, chat: @chat)
      redirect_to show_exploreo_path(@chat)
    else
      @assistant_messages = @chat.messages.where(role: "assistant")
      render :new_exploreo, status: :unprocessable_entity
    end
  end

  def create_stops_from_json(response_as_json)
    response_as_json["stops"].each do |s|
      Stop.create(city: s["city"], travel: @travel)
    end
  end

  def show_exploreo
    @chat = Chat.find(params[:id])
    @travel = @chat.travel
    @stops = @travel.stops
    @assistant_messages = @chat.messages.where(role: "assistant")
  end

  def build_conversation_history
    @ruby_llm_chat = RubyLLM.chat
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message({
        role: message.role,
        content: message.content
      })
    end
  end

  private

  def message_params
    params.require(:message).permit(:country, :content, :number_of_travellers, :trip_duration, :budget)
  end

  def travel_params
    params.require(:travel).permit(:country, :number_of_travellers, :budget, :trip_duration, :departure_date, :return_date, :departure_city, :travellers_type, :photo)
  end

  def instructions
    SYSTEM_PROMPT
  end
end
