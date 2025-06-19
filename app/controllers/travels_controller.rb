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

  ### ROLE
  - Destination expert
  - Booking assistant

  ### TASK
  1. Utilise les préférences du voyageur (qui suivront) pour construire un itinéraire détaillé, jour par jour, dans un style narratif, immersif et inspirant.
  2. Pour chaque **jour** et chaque **stop** (ville ou lieu principal) :
  - Commence chaque jour par un titre clair (ex : "Jour 1 : Arrivée à Chamonix").
  - Décris les activités du matin, de l'après-midi et du soir sous forme de paragraphes ou de listes à puces, comme dans un carnet de voyage.
  - Insère les liens URL directement après le nom de chaque activité, restaurant ou hébergement (ex : "Hôtel Le Morgane : https://www.lemorgane-chamonix.com").
  - Regroupe à la fin de chaque jour les suggestions d'hébergements, de restaurants et d'activités/excursions sous forme de listes à puces, avec nom + URL.
  - Structure l'ensemble pour qu'il soit agréable à lire et donne envie de voyager, avec des sauts de ligne et une mise en forme claire.
  3. Termine par un résumé du séjour (≤ 200 mots), en français sauf demande contraire, sous un titre "Résumé de votre séjour".
  4. Ajoute à la fin une phrase d'ouverture à la personnalisation (ex : "Si vous souhaitez que je personnalise cet itinéraire selon votre durée, votre budget ou d'autres préférences, n'hésitez pas à me le préciser !").
  5. Les liens doivent être réels et accessibles (pas de liens fictifs ou génériques).

  ### OUTPUT FORMAT
  Réponds **uniquement** avec un _tableau JSON_ contenant exactement deux éléments et rien d'autre :
  - Le premier élément est une chaîne Markdown parfaitement lisible et structurée respectant le schéma ci-dessous.
  - Le deuxième élément est un objet JSON respectant le schéma précisé ci-dessous.
  - Les deux éléments doivent être séparés par une **virgule**.
  - Le premier caractère de ta réponse doit être `[` et le dernier caractère doit être `]`.


  ### IMPORTANT
  - **Aucune décoration dans la chaîne Markdown**.
  - Les clés JSON doivent être entre guillemets doubles.
  - Le JSON doit être parfaitement valide et bien formaté.
  - Si le JSON n'est pas valide, la réponse sera considérée comme incorrecte.
  - Utilise des dates ISO-8601.
  - Fournis des liens réels et accessibles.
  - Rédige la partie texte en **français** sauf demande contraire.
  - Fais en sorte de préciser le même nombre de jours dans toute ta réponse.
  - Répartis les activités sur 4 villes maximum, voir moins en fonction de la durée du séjour.
  - Si le voyageur n'a pas précisé de durée, propose un séjour de 4 à 5 jours.
  - Si tu proposes des villes, donne l'adresse exacte de chaque ville (ex : "Chamonix, France") dans les stops.
  - Tous les retours à la ligne dans la chaîne Markdown doivent être encodés sous forme \\n (pas de sauts de ligne littéraux).

  ### OUTPUT STRUCTURE
  [
    "<ELEMENT MARKDOWN>",
    {
      "country": "<string>",
      "stops": [
        {
          "city": "<string>",
          "date": "<ISO-8601>",
          "morning_activity": { "name": "<string>", "url": "<string>" },
          "afternoon_activity": { "name": "<string>", "url": "<string>" },
          "evening_activity": { "name": "<string>", "url": "<string>" },
          "hotels": [ { "name": "<string>", "url": "<string>" } ],
          "restaurants": [ { "name": "<string>", "url": "<string>" } ],
          "excursions": [ { "name": "<string>", "url": "<string>" } ]
        }
      ],
      "summary": "<string>"
    }
  ]

  ### AFFICHAGE
  Structure l'itinéraire comme un carnet de voyage :
  - Titres pour chaque jour
  - Paragraphes ou listes pour les activités
  - Suggestions d'hébergements, restaurants, activités avec noms et URLs en liste à puces
  - Un résumé global du séjour à la fin
  - Une phrase d'ouverture à la personnalisation

  Mets en valeur chaque jour, chaque activité, chaque suggestion, pour un rendu aussi immersif et inspirant que l'exemple ci-dessous.

  ### EXEMPLE D'AFFICHAGE ATTENDU
  Itinéraire Ski à Chamonix : Jour par Jour

  **Jour 1 : Arrivée et installation**

  Arrivée à Chamonix, installation dans votre hébergement (hôtel, location ou refuge).
  Balade dans le centre-ville, découverte des boutiques et cafés.
  Dîner dans un restaurant typique savoyard.

  **Suggestions pour cette journée :**

  Hébergements :
  - Hôtel Le Morgane : https://www.lemorgane-chamonix.com
  - Les Granges d'en Haut : https://www.lesgrangesdenhaut.com
  - Chamonix Lodge : https://www.chamonixlodge.com

  Restaurants :
  - La Calèche : https://www.restaurantlacaleche.com
  - Le Panier des 4 Saisons : https://www.panier4saisons.com

  Activités :
  - Forfaits de ski Chamonix : https://www.chamonix.com/forfaits
  - Location de matériel : https://www.skiset.com/station/chamonix

  ---

  **Résumé de votre séjour :**

  Vous passerez 4 à 5 jours à Chamonix, mêlant ski pour tous niveaux, découvertes panoramiques, activités hors-piste, et détente. Vous profiterez d'un cadre exceptionnel entre montagnes majestueuses, activités variées et gastronomie savoyarde. Ce séjour sera parfait pour vivre une expérience de ski authentique et mémorable !

  Si vous souhaitez que je personnalise cet itinéraire selon votre durée, votre budget ou d'autres préférences, n'hésitez pas à me le préciser !

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
    @travel = Travel.create!(user: current_user, country: "France")
    @chat   = Chat.create!(title: "Untitled", model_id: "gpt-4.1-mini", user: current_user, travel: @travel)

    @message = Message.create!(role: "user", chat: @chat, content: params[:user_input])

    build_conversation_history
    raw_response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

    begin
      parsed      = JSON.parse(raw_response.content)     # ← peut lever JSON::ParserError
      markdown    = parsed[0]
      structured  = parsed[1]

      create_stops_from_json(structured)
      Message.create!(role: "assistant", content: markdown, chat: @chat)
      @travel.update(country: structured["country"]) if structured["country"].present?
      redirect_to show_exploreo_path(@chat)

    rescue JSON::ParserError => e
      Rails.logger.error "LLM JSON parse failed: #{e.message}"
      flash.now[:alert] = "Je n'ai pas réussi à comprendre la réponse. Réessaie ou reformule ta demande !"
      @assistant_messages = @chat.messages.where(role: "assistant")
      render :new_exploreo, status: :unprocessable_entity
    end
  end


  def create_stops_from_json(response_as_json)
    return if response_as_json["stops"].nil? || response_as_json["stops"].empty?

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
