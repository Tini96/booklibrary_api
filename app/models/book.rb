class Book < ApplicationRecord
  belongs_to :author

  validates :hard_copies, presence: true, on: :create
end
