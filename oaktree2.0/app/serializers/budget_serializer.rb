class BudgetSerializer < ActiveModel::Serializer
  attributes :name, :id, :limit, :total_expense
end
