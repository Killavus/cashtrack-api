class AuthorizationAdapter
  StrategyRequired = Class.new(StandardError)

  def use(strategy)
    @strategy = strategy
    self
  end

  def has_access_to_budget?(budget)
    raise StrategyRequired.new unless strategy
    strategy.has_access_to_budget?(budget)
  end

  private
  attr_reader :strategy
end