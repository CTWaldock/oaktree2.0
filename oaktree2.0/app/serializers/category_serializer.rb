class CategorySerializer < ActiveModel::Serializer
  attributes :id, :subtotal, :title
  has_many :expenses
  has_one :budget
end
