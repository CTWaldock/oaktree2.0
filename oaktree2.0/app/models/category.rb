class Category < ActiveRecord::Base
  belongs_to :budget
  has_many :expenses, :dependent => :delete_all
  before_destroy :subtract_from_budget
  # could potentially use :dependent => destroy instead which would trigger the before destroy expense callbacks to subtract cost from budget, but would be more time intensive

  def current_percentage
    if budget.total_expense == 0
      return 0
    else
      ((self.subtotal / budget.total_expense) * 100).round
    end
  end

  def total_percentage
    ((self.subtotal / budget.limit) * 100).round
  end

  private

  def subtract_from_budget
    budget.total_expense -= self.subtotal
    budget.save
  end

end
