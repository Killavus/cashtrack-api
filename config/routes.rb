Rails.application.routes.draw do
  resources :budget, only: [:show, :create] do
    resources :payments, only: :create
    resources :shopping, only: :create

  end

  resources :authentication, only: [:create, :index]

  resources :shopping, only: [:create, :destroy]

  resources :budget, only: [] do
    resources :sessions
  end


  get '/budgetoverview' => 'budgets_overview#show_for_user', constraints: UserConstraint
  get '/budgetoverview' => 'budgets_overview#show_for_session', constraints: SessionConstraint

end
