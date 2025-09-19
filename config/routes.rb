Rails.application.routes.draw do
  namespace :admin do
    get 'orders/show'
  end
  namespace :public do
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


  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  namespace :public do
    resources :customers, only: [:show, :edit, :update] do
      member do
        get :unsubscribe
        patch :withdraw
      end
    end
  end


  namespace :admin do
    resources :items, only: [:new, :create, :index, :show, :edit, :update]
    resources :orders, only: [:show, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
