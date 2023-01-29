class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :hard_copies
  belongs_to :author
  has_many :loans
end