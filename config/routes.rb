Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:update]
  
  resources :topics do
    resources :posts, except: [:index]
  end

  resources :posts, only: [] do
    resources :comments, only: [:create, :destroy]
  end

  resources :posts, only: [] do
    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote
    post '/remove-up-vote' => 'votes#remove_up_vote', as: :remove_up_vote
    post '/remove-down-vote' => 'votes#remove_down_vote', as: :remove_down_vote
  end

  post 'favorites/:post_id' => 'favorites#create'
  delete 'favorites/:post_id' => 'favorites#destroy', as: :favorites

  get 'about' => 'welcome#about'
  get 'contact' => 'welcome#contact'

  root to: 'welcome#index'
end
