class RetrieveBudgetsForSession
  SessionNotFound = Class.new(StandardError)
  InvalidSecret = Class.new(StandardError)

  def call(session_id, secret)
    session = find_session(session_id)
    raise InvalidSecret unless valid_secret?(session, secret)
    find_budgets(session_id)
  end

  private
  def find_session(session_id)
    session = Session.find_by(id: session_id)
    raise SessionNotFound.new('session not found') unless session.present?
    session
  end

  def find_budgets(session_id)
    budgets = Budget.where(session_id: session_id)
  end

  def valid_secret?(session, secret)
    session.secret == secret
  end

end