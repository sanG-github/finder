Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items
      resources :folders
      resources :resources, only: %i(create destroy)
    end
  end
end
