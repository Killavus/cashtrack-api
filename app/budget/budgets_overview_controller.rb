class BudgetsOverviewController < ApplicationController

  def show_for_user
    overview = prepare_overview(prepare_budgets_for_user)
    render json: overview
  end

  def show_for_session
    overview = prepare_overview(prepare_budgets_for_session)
    render json: overview
  rescue RetrieveBudgetsForSession::InvalidSecret
    render json: { errors: { message: 'session secret is invalid' } }
  rescue RetrieveBudgetsForSession::SessionNotFound
    render json: { errors: { message: 'there is no session for that id' } }
  end

  private
  def prepare_overview(budgets)
    prepare_budgets_overview = PrepareBudgetOverviewObject.new
    prepare_budgets_overview.prepare_for_budgets(budgets)
  end

  def prepare_budgets_for_user
    retrieving_budgets = RetrieveBudgetForUser.new
    authenticate_via_token = AuthenticateViaToken.new
    retrieving_budgets.(authenticate_via_token.(request.headers['X-Authentication-token'] ) )
  end

  def prepare_budgets_for_session
    retrieving_budgets = RetrieveBudgetsForSession.new
    retrieving_budgets.(request.headers['X-Session-Id'], request.headers['X-Session-secret'] )
  end
end