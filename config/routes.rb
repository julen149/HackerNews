Rails.application.routes.draw do
  
  resources :votes
  resources :contributions do
    member do
      post 'upvote'
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }
  
  root 'home#index'
  post '/vote' => 'votes#create'
  get '/home/new'
  get '/home/ask'
  post '/contributions' => 'contributions#show'
  get '/contributions/discuss/:id' => 'contributions#discuss'
  get '/contributions/reply/:id' => 'contributions#reply'
  
  devise_scope :user do
    get "/users/:id" => "users/registrations#show"
  end
  
  get '/api/posts/url' => 'contributions#api_url'
  get '/api/posts/ask' => 'contributions#api_ask'
  get '/api/comments/:id' => 'contributions#api_comment'
  get '/api/posts/:id' => 'contributions#api_post'
  get '/api/replies/:id' => 'contributions#api_get_reply'
  
  post '/api/posts' => 'contributions#create_posts_api'
  post '/api/replies' => 'contributions#create_reply_api'
  post '/api/comments' => 'contributions#create_comment_api'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
