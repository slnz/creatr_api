Rails.application.routes.draw do
  root to: redirect(ENV['root_url'] || 'http://creatr.io')
  devise_for :users
  use_doorkeeper
end
