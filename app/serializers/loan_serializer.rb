class LoanSerializer < ActiveModel::Serializer
  attributes :id, :is_returned, :created_at
  belongs_to :user
  belongs_to :book
end
