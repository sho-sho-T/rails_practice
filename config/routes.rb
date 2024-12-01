Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :all_members, only: [ :index ]
    end
  end
end
