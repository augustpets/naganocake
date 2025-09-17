Rails.application.routes.draw do

  devise_for :admins
  devise_for :customers

  namespace :admin do
    resources :items, only: [:new, :create, :index, :show, :edit, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
