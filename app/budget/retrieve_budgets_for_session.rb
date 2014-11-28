class RetrieveBudgetsForSession
  SessionNotFound = Class.new(StandardError)
  InvalidSecret = Class.new(StandardError)

  def call(session_id, secret)
    session = find_session(session_id)
    raise InvalidSecret unless valid_secret?(session, secret)
    find_budgets(session_id)
  end

  def find_session(session_id)
    session = Session.find_by(id: session_id)
    raise SessionNotFound.new unless session.present?
  end

  def find_budgets(session_id)
    budget = Budget.find_by(session_id: session_id)
    budget.present? ? budget : []
  end

  def valid_secret?(session, secret)
    session.secret == secret
  end

end