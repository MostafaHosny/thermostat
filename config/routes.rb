require "sidekiq/web"

Rails.application.routes.draw do
  namespace :v1 do
    resources :readings, only: %i[create show] do
      collection do
        get :stats
      end
    end
  end
  mount Sidekiq::Web => "/sidekiq"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
