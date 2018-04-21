class Expense < ActiveRecord::Base
  belongs_to :category
  validates :description, :category, :cost, presence: true
  validates :cost, numericality: true
  after_save :add_to_budget_and_category
  before_destroy :remove_from_budget_and_category
  before_update :remove_from_budget_and_category

  def category_percentage
    ((self.cost / self.category.subtotal) * 100).round
  end

  private

  # NOTE: Alternatively, use ActiveRecord to sum expenses for both category and budget. Current approach breaks database normalization rules by introducing redundant information into category and budget and is only necessary in case of actual performance issues. Consider refactoring -- currently a case of premature optimization.

  def add_to_budget_and_category
    budget = category.budget
    category.subtotal += self.cost
    category.save
    budget.total_expense += self.cost
    budget.save
  end

  def remove_from_budget_and_category
    budget = category.budget
    category.subtotal -= self.cost_was
    category.save
    budget.total_expense -= self.cost_was
    budget.save
  end

end
