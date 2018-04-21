class CategoryPolicy < ApplicationPolicy

  def show?
    record.budget.user == user
  end

  def destroy?
    record.budget.user == user
  end

end
