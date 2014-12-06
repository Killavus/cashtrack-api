class BudgetOverview

  def initialize
    @budgets = []
  end

  def add_budget(budget)
    @budgets << budget
  end

  def get_overview_list
    @budgets
  end
end

