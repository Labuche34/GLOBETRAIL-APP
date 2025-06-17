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
    1. Utilise les préférences du voyageur (qui suivront) pour construire un itinéraire jour-par-jour.
    2. Pour chaque **stops**, indique :
       • ville / lieu principal
       • activités matin, après-midi, soir
       • **3** hébergements (URL)
       • **3** restaurants (URL)
       • **3** activités ou excursions (URL)
    3. Termine par un résumé du séjour (≤ 120 mots).

    ### OUTPUT FORMAT
    Réponds **uniquement** avec un _tableau JSON_ contenant deux éléments :

    0 → une chaîne Markdown lisible pour l’humain (itinéraire + résumé)
    1 → un objet JSON respectant exactement ce schéma :

    {
      "country": "<string>",
      "stops": [
        {
          "city": "<string>",
        }
      ]
    }

    ### RULES
    * Le premier caractère de ta réponse doit être "[" et le dernier "]" ; **aucun** texte hors du tableau.
    * Les clés sont toujours entre guillemets doubles et le JSON doit être valide.
    * Utilise des dates ISO-8601.
    * Fournis de vraies URLs accessibles.
    * Rédige la partie texte en **français**, sauf demande contraire du voyageur.
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
    params.require(:travel).permit(:country, :number_of_travellers, :budget, :trip_duration, :departure_city, :travellers_type, :photo)
  end

  def instructions
    SYSTEM_PROMPT
  end
end
