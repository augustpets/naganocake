Rails.application.routes.draw do

  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  root :to =>"homes#top"
  get "about", to: "homes#about", as: "about"

  scope module: :public do
    get '/customers/mypage' => 'customers#show'
    get '/customers/information/edit' => 'customers#edit'
    patch '/customers/information' => 'customers#update'
    get '/customers/unsubscribe' => 'customers#unsubscribe'
    patch '/customers/withdraw' => 'customers#withdraw'

    delete '/cart_items/destroy_all' => 'cart_items#destroy_all'

    post 'orders/confirm' => 'orders#confirm'
    get 'orders/thanks' => 'orders#thanks'

    resources :items, only: [:index, :show]
    resources :cart_items, only: [:index, :create, :update, :destroy]
    resources :orders, only: [:new, :create, :index, :show]
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
    resources :genres, only: [:show]
  end

  namespace :admin do
    root :to =>'homes#top'

    resources :items, only: [:new, :create, :index, :show, :edit, :update]
    resources :genres, only:[:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:index, :show, :update] do
      resources :order_details, only: [:update]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
