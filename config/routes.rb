Rails.application.routes.draw do
  namespace :public do
    get 'addresses/index'
    get 'addresses/create'
    get 'addresses/edit'
    get 'addresses/update'
    get 'addresses/destroy'
  end
  namespace :admin do

    root :to =>'homes#top'

    resources :orders, only: [:index, :show, :update] do
      resources :order_details, only: [:update]
    end
  end

  namespace :public do
    resources :customers, only: [:show, :edit, :update] do
      member do
        get :unsubscribe
        patch :withdraw
      end
    end
    resources :items, only: [:index, :show]
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post 'confirm'
        get 'thanks'
      end
    end

    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
  end

  
  
  root "homes#top"
  get "about", to: "homes#about", as: "about"


  scope module: :public do
    resources :cart_items, only: [:index, :create, :update, :destroy] do
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

  namespace :admin do
    resources :items, only: [:new, :create, :index, :show, :edit, :update]

    resources :genres, only:[:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
