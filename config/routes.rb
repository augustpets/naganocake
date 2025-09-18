Rails.application.routes.draw do
  namespace :public do
    get 'orders/new'
    get 'orders/confirm'
    get 'orders/thanks'
    get 'orders/create'
    get 'orders/index'
    get 'orders/show'
  end

  
  
  root "homes#top"
  get "about", to: "homes#about", as: "about"


  scope module: :public do
    resources :cart_items, only: [:index, :create, :destroy] do
      delete :destroy_all, on: :collection
    end
  end


  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  resources :customers, only: [:show]


  namespace :admin do
    resources :items, only: [:new, :create, :index, :show, :edit, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
