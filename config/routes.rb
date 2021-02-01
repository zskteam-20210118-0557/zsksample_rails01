Rails.application.routes.draw do
  resources :users
  resources :microposts
  root 'application#hello'
end
