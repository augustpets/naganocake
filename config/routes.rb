Rails.application.routes.draw do

  
  
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



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
