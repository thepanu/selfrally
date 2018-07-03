Rails.application.routes.draw do

  get 'ribbons/index'

  #get 'games/prepare_players', to: 'games#prepare_players'
  resources :games
  resources :ribbons

  resources :users do
    member do
      get 'games'
    end
  end

  resources :scenarios do
#    resources :comments, module: :scenarios
  end
  resources :publications
  resources :publishers
  # get 'publisher/:id', to: 'publishers#show', as: 'publisher_show'
  get 'publisher/:slug', to: 'publishers#show', as: 'publisher_show'
  get 'publisher/:slug/edit', to: 'publishers#edit', as: 'publisher_edit'
  get 'publisher/:slug/destroy', to: 'publishers#destroy', as: 'publisher_destroy'
  get 'publication/:slug', to: 'publications#show', as: 'publication_show'
  get 'publication/:slug/edit', to: 'publications#edit', as: 'publication_edit'
  get 'publication/:slug/destroy', to: 'publications#destroy', as: 'publication_destroy'
  get 'scenario/:slug', to: 'scenarios#show', as: 'scenario_show'
  get 'scenario/:slug/comments', to: 'scenarios#comments#index', as: 'scenario_comments'
  post 'scenario/:slug/comments', to: 'scenarios/comments#create'
  get 'scenario/:slug/edit', to: 'scenarios#edit', as: 'scenario_edit'
  get 'scenario/:slug/destroy', to: 'scenarios#destroy', as: 'scenario_destroy'
  get 'admin/users'
  # get 'admin/edit_user'
  # resources :admin

  mount Thredded::Engine => '/forum'

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'edit' }

  # namespace :admin do
  #   resources :users
  # end
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
