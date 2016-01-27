Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      controller :sessions do
        post :login, action: :create
      end
      resources :users, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
