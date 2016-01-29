Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      controller :sessions do
        post :login, action: :create
      end

      resources :users, only: [:index, :create, :show, :update, :destroy] do
        resources :blogs, only: [:create, :show, :update, :destroy], shallow: true
      end
      resources :blogs, only: [] do
        resources :comments, only: [:create, :update, :destroy, :index]
      end
      resources :blogs, only: [:index]
    end
  end
end
