Rails.application.routes.draw do
  namespace :admin do
    get 'orders/show'
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
<<<<<<< HEAD
    resources :genres, only:[:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
=======
    resources :orders, only: [:show, :update]
>>>>>>> feature/order
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
