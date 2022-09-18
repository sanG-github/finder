Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items
      resources :folders
      resources :resources do
        post :cr, on: :collection
        delete :rm, on: :collection
      end
    end
  end
end
