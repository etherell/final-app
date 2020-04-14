Rails.application.routes.draw do

  # Static pages routes
  root'static_pages#home'
  get 'help' 	=> 	'static_pages#help'
  get 'about' 	=> 	'static_pages#about'
  get 'contact' => 	'static_pages#contact'

  # Session routes
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # User routes
  get 'signup'	=>	'users#new'
  resources :users

  # Comments and articles routes
  resources :articles do
    resources :comments, only: [:create, :destroy]
  end
  
  # Account_activations routes
  resources :account_activations, only: [:edit]

  # Password_resets routes
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
end
