Mktdemo::Application.routes.draw do
  

  devise_for :users

  resources :users, only: [:update, :edit]

  #match "/seller/:id", to: "users#sellerprofile", via: [:get, :put], as: :sellerprofile

  #match "/seller/:id/profile", to: "users#sellerp", via: [:get], as: :sellerp
  #match "/seller/:id", to: "users#sellerprofile", via: [:put], as: :sellerprofile

  get '/seller/:id/profile' => "users#sellerp", as: :sellerp
  put '/seller/:id' => "users#sellerprofile", as: :sellerprofile

  resources :listings do
        collection do
          post 'import'
          get 'search'
          get 'ownsearch'
          get 'delete_all'
        end
   resources :orders, only: [:new, :create, :update, :show]
  end

  get 'swh' => 'orders#swh' #stripe webhooks

  get '/listings/s/:id' => 'listings#vendor', as: 'vendor'
  get '/listings/c/:category' => 'listings#category', as: 'category'
  get '/listings/p/sale' => 'listings#sale', as:'sale'

  get "pages/about"
  get "pages/contact"
  get "pages/terms_conditions"
  get "pages/privacy_policy"
  get "pages/blogger_partnerships"
  get "pages/sell"
  get "pages/sellerfaqs"
  get "pages/csvimport"
  get "pages/returns"


  get 'seller' => "listings#seller"
  get 'check_listing_status' => "listings#check_listing_status"
  get 'sales' => "orders#sales"
  get 'shipconf' => "orders#shipconf"
  get 'purchases' => "orders#purchases"
  get 'thankyou' => "orders#thankyou"
  #get 'search' => "listings#search"
  get 'admin' => "listings#admin"
  
  #get 'orderupdate' => "orders#update"
  #patch 'orderupdate' => "orders#update" 
  #put 'orderupdate' => "orders#update"

  root 'listings#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
