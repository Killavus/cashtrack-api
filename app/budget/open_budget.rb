class OpenBudget
  SessionNotFound = Class.new(StandardError)
  InvalidBudgetName = Class.new(StandardError)

  def call(name, session_id)
    budget = prepare_budget(name)
    find_session(session_id).budgets << budget
    budget

  rescue ActiveRecord::RecordNotFound
    raise SessionNotFound.new('session not found')
  rescue ActiveRecord::RecordInvalid
    raise InvalidBudgetName.new('budget name is invalid')
  end

  def find_session(session_id)
    Session.find(session_id)
  end

  def prepare_budget(name)
    Budget.create!(name: name)
  end
end