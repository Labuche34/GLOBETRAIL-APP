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

  SYSTEM_PROMPT = "You are a travel planner who creates personalized travel itineraries for any type of traveler.\n\n
  I am a traveler and I ask you to book me a travel\n\n
  Based on these preferences, generate a daily itinerary.\n\n
  Format your response as a day-by-day list and include specific url links to go on the website (3 proposals for each categories).\n\n
  You will use this information to suggest the best trip.\n\n
  Finally, edit a short summary of my trip.\n\n
  Structure the answer in two parts: first part in text format; second part in JSON.\n\n
  The 'stops' will be cities that you'll find.
  This JSON part will be structure like this: {
  country:,
  stops: {
    city:,
    }
  }"

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
      Message.create(role: "assistant", content: @response.content, chat: @chat)
      redirect_to show_exploreo_path(@chat)
    else
      @assistant_messages = @chat.messages.where(role: "assistant")
      render :new_exploreo, status: :unprocessable_entity
    end
  end

  def show_exploreo
    @chat = Chat.find(params[:id])
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
