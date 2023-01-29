class Book < ApplicationRecord
  belongs_to :author
  has_many :loans
  validates :hard_copies, presence: true, on: :create


  public
    def out_of_stock?
      self.hard_copies - self.loans.where(is_returned: false).count == 0
    end
end
