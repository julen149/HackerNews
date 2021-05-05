Rails.application.routes.draw do
  
  resources :votes
  resources :contributions do
    member do
      post 'upvote'
    end
  end

  devise_for :users
  root 'home#index'
  post '/vote' => 'votes#create'
  get '/home/new'
  post '/contributions' => 'contributions#show'
  get '/contributions/discuss/:id' => 'contributions#discuss'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
