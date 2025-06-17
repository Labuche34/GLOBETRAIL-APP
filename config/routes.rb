Rails.application.routes.draw do
  get 'pages/home'
  root to: "pages#home"

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :travels do
    resources :chats, only: [:create, :show, :index]
    resources :stops, only: [:create, :edit, :update] do
      resources :notes, only: [:index, :new, :create, :update]
      resources :pictures, only: [:index, :new, :create, :update]
      resources :spendings, only: [:index, :new, :create, :update]
    end
  end

  resources :chats, only: [:show] do
    resources :messages, only: [:create]
  end

  resources :stops, only: [:show, :destroy]
  resources :notes, only: [:destroy]
  resources :pictures, only: [:destroy]
  resources :spendings, only: [:destroy]

  get "new_exploreo" => "travels#new_exploreo"
  post "create_exploreo" => "travels#create_exploreo"
  get "show_exploreo/:id" => "travels#show_exploreo", as: "show_exploreo"

  # Defines the root path route ("/")
  # root "posts#index"
end
