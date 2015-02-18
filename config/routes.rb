Rails.application.routes.draw do
  resources :budget, only: [:show, :create] do
    resources :payments, only: :create
    resources :shopping, only: :create
  end

  resources :authentication, only: [:create, :index] do
    collection do
      post :map_with_user
    end
  end

  resources :shopping, only: [:create, :destroy]
  resources :sessions, only: [:create]

  get '/budgetoverview' => 'budgets_overview#show_for_user', constraints: UserConstraint
  get '/budgetoverview' => 'budgets_overview#show_for_session', constraints: SessionConstraint

end
