class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book
  before_validation :set_defaults, on: :create

  default_scope { order(created_at: :asc) }
  
  private
    def set_defaults
      self.is_returned ||= false
    end
end
