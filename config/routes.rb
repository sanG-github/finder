Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :folders
      resources :items do
        get :cat, on: :collection
      end
      resources :resources do
        post :cr, on: :collection
        delete :rm, on: :collection
      end
    end
  end
end
