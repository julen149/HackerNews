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
  get '/home/ask'
  post '/contributions' => 'contributions#show'
  get '/contributions/discuss/:id' => 'contributions#discuss'
  get '/contributions/reply/:id' => 'contributions#reply'
  
  get '/api/posts/url' => 'contributions#api_url'
  get '/api/posts/ask' => 'contributions#api_ask'
  
  post '/api/posts' => 'contributions#create_posts_api'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
