class UserAuthorizationStrategy
  def initialize(user)
    @user = user
  end

  def has_access_to_budget?(budget)
    user.budgets.include?(budget)
  end

  private
  attr_reader :user
end