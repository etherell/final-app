Rails.application.routes.draw do
  # Маршруты для статических страниц
  root'static_pages#home'
  get 'help' 	=> 	'static_pages#help'
  get 'about' 	=> 	'static_pages#about'
  get 'contact' => 	'static_pages#contact'

  # Маршруты для сессий
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  #Марруты для юзера
  get 'signup'	=>	'users#new'
  resources :users
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
