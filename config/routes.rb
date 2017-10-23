Rails.application.routes.draw do
  resources :publishers
  #get 'publisher/:id', to: 'publishers#show', as: 'publisher_show'
  get 'publisher/:slug', to: 'publishers#show', as: 'publisher_show'
  get 'admin/users'
  #get 'admin/edit_user'
  #resources :admin

  devise_for :users, path: '', path_names: {sign_in: "login", sign_out: "logout", sign_up: "register", edit: "edit"}

  # namespace :admin do
  #   resources :users
  # end
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
