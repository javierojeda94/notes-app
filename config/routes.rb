Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'login' => 'auth#login'
  post 'signup' => 'auth#signup'

  resources :notes

  scope 'users/:user_id' do
    resources :notes, only: [:index, :show]
  end

end
