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
  get '/threads' => 'home#threads'
  
  devise_scope :user do
    get "/users/:id" => "users/registrations#show"
    get '/api/users/:id' => 'users/registrations#api_show'
    put 'api/users/:id' => 'users/registrations#api_update'
    get 'api/users/:id/threads' => 'users/registrations#api_threads'
    get 'api/me' => 'users/registrations#api_me'
  end
  
  get '/api/posts/all' => 'contributions#api_all'
  get '/api/posts/url' => 'contributions#api_url'
  get '/api/posts/ask' => 'contributions#api_ask'
  get '/api/posts/n_comm/:id' => 'contributions#api_num_comments'
  get '/api/comments/:id' => 'contributions#api_comment'
  get '/api/posts/:id' => 'contributions#api_post'
  get '/api/replies/:id' => 'contributions#api_get_reply'
  
  get '/api/votes/:id' => 'votes#show_api'
  
  post '/api/posts' => 'contributions#create_posts_api'
  post '/api/replies' => 'contributions#create_reply_api'
  post '/api/comments' => 'contributions#create_comment_api'
  
  post '/api/votes' => 'votes#create_api'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
