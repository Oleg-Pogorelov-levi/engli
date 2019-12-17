Rails.application.routes.draw do

  devise_for :users, controllers: { confirmations: 'confirmations' }
  root 'phrases#index'
  get 'hello' => 'static_pages#hello'
  put 'activities/read_all' => 'activities#read_all'
  resources :users
  
  resources :activities
  resources :phrases do
    member do
      post :vote
    end
    resources :examples, only: [:create, :destroy] do
      post :vote
    end
  end
  match '*unmatched', to: 'error404#not_found', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

