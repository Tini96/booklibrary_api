require "test_helper"

class LoanTest < ActiveSupport::TestCase
  test "is_returned default set on false" do
    book = books(:one)
    user = users(:two)
    loan = Loan.new(book: book, user:user)
    assert_not loan.is_returned?, "is_returned should be false by default"
  end

end