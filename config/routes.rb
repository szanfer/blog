Blog::Application.routes.draw do
  require 'api_constraints'

  match '/auth/:provider/callback' => 'authentications#create'
  
  devise_for :admins, :controllers => { :sessions => 'admin/sessions', :registrations => 'admin/registrations' }

  namespace :admin do
      resources :users
      resources :celebrations

      authenticated :admin do
        root :to => 'admins#dashboard'
      end

      devise_scope :admin do
        root :to => 'sessions#new'
      end
  end

  devise_for :users, :controllers => {:registrations => 'registrations'}

  resources :posts do
    resources :comments
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      get 'celebrations/(:til)' => 'celebrations#index'
      get 'facebook/upcoming_birthdays/(:til)' => 'facebook#upcoming_birthdays'
      get 'facebook/photos_together/(:til)' => 'facebook#photos_together' 
    end
  end

  get '/invite' => 'home#invite'

  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
