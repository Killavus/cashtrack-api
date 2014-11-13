Rails.application.routes.draw do
  resources :budget, only: [:show, :create]
end
