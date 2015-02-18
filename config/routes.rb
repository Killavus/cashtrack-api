Rails.application.routes.draw do
  resources :budget, only: [:show, :create, :destroy] do
    resources :payments, only: :create
    resources :shopping, only: :create
  end

  resources :authentication, only: [:create, :index]
  resources :users, only: [:create]

  resources :shopping, only: [:create, :destroy]
  resources :sessions, only: [:create] do
    collection do
      post :link_with_user
    end
  end

  get '/budgetoverview' => 'budgets_overview#show_for_user', constraints: UserConstraint
  get '/budgetoverview' => 'budgets_overview#show_for_session', constraints: SessionConstraint

end
