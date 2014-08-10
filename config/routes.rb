PdfForms::Application.routes.draw do

  root to: 'forms#invoice'
  match '/form130' => 'forms#form130'
  match '/prepayment' => 'forms#prepayment'
  match '/inquiry' => 'forms#inquiry'
  match '/form117' => 'forms#form117'
  match '/form117_back' => 'forms#form117_back'
  match '/form113' => 'forms#form113'
  match '/form113_back' => 'forms#form113_back'
  match '/inquiry_back' => 'forms#inquiry_back'
  match '/act' => 'forms#act'
  match '/invoice_for_payment' => 'forms#invoice_for_payment'
	match '/form113en' => 'forms#form113en'
	match '/form113en_mailing' => 'forms#form113en_mailing'
	match '/backform113en' => 'forms#backform113en'
  match '/form22' => 'forms#form22'
  match '/form22_back' => 'forms#form22_back'
  match '/search' => 'forms#search'
  match '/form112ep' => 'forms#form112ep'
  
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
