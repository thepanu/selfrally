Rails.application.routes.draw do
  get 'admin/users'

  devise_for :users, path: '', path_names: {sign_in: "login", sign_out: "logout", sign_up: "register", edit: "edit"}
  #get 'pages/home'
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
