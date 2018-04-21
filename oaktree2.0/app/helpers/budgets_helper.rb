module BudgetsHelper

  def budget_categories(budget)
    while budget.categories.length < 10 do
      budget.categories.build
    end
    budget.categories
  end

  def show_budget_status(budget)
    if budget.status == "Inactive"
      "This budget is not yet active. It starts at #{budget.start_date.strftime("%B %e, %Y")} and ends at #{budget.end_date.strftime("%B %e, %Y")}."
    elsif budget.status == "Complete"
      "This budget has been completed. It started at #{budget.start_date.strftime("%B %e, %Y")} and ended at #{budget.end_date.strftime("%B %e, %Y")}."
    else
      "Budget in progress with #{pluralize(budget.remaining_days, 'day')} left. It started at #{budget.start_date.strftime("%B %e, %Y")} and ends at #{budget.end_date.strftime("%B %e, %Y")}."
    end
  end

  def show_budget_recommendation(budget)
    if budget.status == "Inactive"
      "Once your budget begins, you can spend up to #{number_to_currency(budget.recommended_expenditure)} on a daily basis."
    elsif budget.status == "Complete"
      "Your average daily expenditure was #{number_to_currency(budget.average_expenditure)}."
    else
      "Your current average of daily expenses is #{number_to_currency(budget.average_expenditure)}. In order to meet your budget goals, you can spend up to
        #{number_to_currency(budget.recommended_expenditure)} on a daily basis."
    end
  end


end
