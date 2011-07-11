Haidb::Application.routes.draw do
  devise_for :staffs	# office people

  filter :locale

  root :to => "public_signups#new"
  
  # participant signup
  resources :public_signups, :only => [:new, :create]

  namespace :office do

    resources :angels do
      resources :registrations
      collection do
        get 'level'
        get 'map'
        get 'map_info'
      end
    end
  
    resources :events do
      collection do
        get 'upcoming'
        get 'past'
      end
      resources :registrations
      scope :module => "registrations" do
        resources :pre, :only => [:index]
        resources :post, :only => [:index]
        resources :completed, :only => [:index, :create, :update]
        resources :checked_in, :only => [:index, :create, :update]
        resources :payment, :only => [:index]
        resources :checklist, :only => [:index]
        resources :roster, :only => [:index]
        resources :map, :only => [:index] do
          collection do
            get 'map_info'
          end
        end
      end
    end

    resources :public_signups do
      collection do
        get 'approved'
        get 'waitlisted'
      end
      member do
        put 'approve'
        put 'waitlist'
      end
    end
    
    resources :site_defaults
    resources :registrations

    match '/dashboards' => "dashboards#index"
    match '/' => "dashboards#index"

  end

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
