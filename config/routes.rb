Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :folders do
        get :roots, on: :collection
        get :ls, on: :collection
      end
      resources :items do
        get :cat, on: :collection
      end
      resources :resources do
        get :find, on: :collection
        post :cr, on: :collection
        put :mv, on: :collection
        put :up, on: :collection
        delete :rm, on: :collection
      end
    end
  end
end
