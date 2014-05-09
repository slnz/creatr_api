Rails.application.routes.draw do
  root to: redirect(ENV['root_url'] || 'http://creatr.io')
  devise_for :users
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :user
    end
  end
end
