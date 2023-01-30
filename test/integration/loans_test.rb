require "test_helper"

class LoansTest < ActionDispatch::IntegrationTest
  fixtures :books, :users, :loans



  setup do
    user_type = user_types(:one)
    user = User.create!(username: "test", email: "test@test.com", name: "Test", password: "test321", user_type: user_type)
    post '/auth/login', params: { email: user.email, password: "test321" }
    
    response_json = JSON.parse(response.body)
    @token = response_json['token']
  end

 

    # retrieve token
    
  test "maximum books rented" do
    user = users(:two)
    book = books(:four)
    post '/loans', params: json(user.id, book.id), headers: { 'Authorization': "Bearer #{@token}" } 
    assert_response :unprocessable_entity
    assert_equal 'The user has reached the maximum book borrowing limit.', JSON.parse(@response.body)['error']
  end

  test "book out of stock" do
    user = users(:three)
    book = books(:one)
    post '/loans', params: json(user.id, book.id), headers: { 'Authorization': "Bearer #{@token}" } 
    assert_response :unprocessable_entity
    assert_equal 'Not enough books available', JSON.parse(@response.body)['error']
  end

  test "successful book rental" do
    user = users(:three)
    book = books(:four)
    post '/loans', params: json(user.id, book.id), headers: { 'Authorization': "Bearer #{@token}" } 
    assert_response :success
  end



  def json(user_id, book_id)
   return {
      data: {
        type: "loans",
        attributes: {
          "is_returned": false
        },
        relationships: {
          user: {
            data: {
                id: user_id.to_s,
                type: "users"
            }
          },
          book: {
            data: {
                id: book_id.to_s,
                type: "books"
            }
          }
        }
      }
    }
  end

end
