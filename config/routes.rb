Surftrottr::Application.routes.draw do
  resources :reports
  resources :posts
  resources :surfboards
  resources :gears

  resources :surf_sessions do
    resources :comments
  end

  resources :surfspots do
    get :browse, :on => :collection
    get :search, :on => :collection
    get :suggest, :on => :collection
    get :sessions, :on => :collection
  end

  resources :suggested_surfspots do
    put :archive, :on => :collection
  end

  root :to => "site#index"

  match "admin" => "site#admin", :as => :admin
  match "surfer/:screen_name" => "surfer#show", :as => :surfer
  match "surfer/:screen_name/bulletins" => "profile#bulletins", :as => :surfer_bulletins
  match "surfer/:screen_name/reports" => "profile#reports", :as => :surfer_reports
  match "surfer/:screen_name/sessions" => "profile#sessions", :as => :surfer_sessions
  match "surfer/:screen_name/photos" => "profile#photos", :as => :surfer_photos
  match "surfer/:screen_name/stats" => "profile#stats", :as => :surfer_stats
  match "surfspots/:id/sessions" => "surfspots#sessions", :as => :surfspot_sessions
  match "surfspots/:id/photos" => "surfspots#photos", :as => :surfspot_photos

  match ':controller(/:action(/:id))'
end
