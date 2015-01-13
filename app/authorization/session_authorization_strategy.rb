class SessionAuthorizationStrategy
  def initialize(session)
    @session = session
  end

  def has_access_to_budget?(budget)
    session.budgets.include?(budget)
  end

  private
  attr_reader :session
end