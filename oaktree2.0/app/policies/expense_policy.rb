class ExpensePolicy < ApplicationPolicy
  # need to make sure users cannot create expenses for budgets that don't belong to them.
  def create?
    record.category.budget.user == user
  end

  def destroy?
    record.category.budget.user == user
  end

end
