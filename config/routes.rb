Rails.application.routes.draw do
  resources :budget, only: [:show, :create] do
    resources :payments, only: :create
    resources :shopping, only: :create

  end
  resources :shopping, only: [] do
    resources :purchases, only: :create

  end

  resources :purchases, only: [] do
    resources :products, only: :create
  end

  resources :product, only: [] do
    resources :prices, only: :create
  end

  resources :prices, only:[] do
    resources :localization, only: :create
  end
end
