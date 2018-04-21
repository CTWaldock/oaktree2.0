class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :cost, :description
end
