Rails.application.routes.draw do
  resources :budget, only: [:show, :create] do
    resources :payments, only: :create
    resources :shopping, only: :create
  end

end
