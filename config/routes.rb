Rails.application.routes.draw do
  devise_for :users
  resources :posts

  get 'about' => 'welcome#about'
  get 'contact' => 'welcome#contact'

  root to: 'welcome#index'
end
