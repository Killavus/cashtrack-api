Rails.application.routes.draw do
  resources :budget, only: [:show, :create] do
    resources :payments, only: :create
  end

end
