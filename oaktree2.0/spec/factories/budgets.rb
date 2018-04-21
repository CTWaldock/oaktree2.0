FactoryGirl.define do
  factory :budget do
    limit 10000.00
    name "My Budget"
    start_date Date.today
    end_date Date.today + 30
    total_expense 0.00

    before(:create) do |budget|
      category = FactoryGirl.create(:category)
      budget.categories << category
    end

  end
end
