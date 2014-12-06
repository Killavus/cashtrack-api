class RetrieveBudgetForUser
  SessionNotFound = Class.new(StandardError)

  def call(user)
    sessions = find_session(user)
    find_session(user).map {|x| find_budgets(x)}.flatten
  end

  private
  def find_session(user)
    session = Session.where(user_id: user.id)
    raise SessionNotFound.new if session.empty?
    session
  end

  def find_budgets(session_id)
    budgets = Budget.where(session_id: session_id)
  end
end
