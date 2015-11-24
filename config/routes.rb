Rails.application.routes.draw do
  devise_for :users
  
  resources :topics do
    resources :posts, except: [:index]
  end

  get 'about' => 'welcome#about'
  get 'contact' => 'welcome#contact'

  root to: 'welcome#index'
end
