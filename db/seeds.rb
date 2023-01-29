Loan.destroy_all
User.destroy_all
UserType.destroy_all
Book.destroy_all
Author.destroy_all


UserType.create!([{
    type_name: "Member"
},
{
    type_name: "Librarian"
}])
p "Created #{UserType.count} UserTypes"

librarian_id = UserType.find_by_type_name("Librarian").id
member_id = UserType.find_by_type_name("Member").id



10.times do
    User.create(
      name: Faker::Name.name,
      username: Faker::Internet.username,
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      user_type_id: member_id
    )
end
5.times do
    User.create(
      name: Faker::Name.name,
      username: Faker::Internet.username,
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      user_type_id: librarian_id
    )
end

p "Created #{User.count} Users"

#Create 10 authors with 10 books each

10.times do |i|
    author = Author.create!(name: Faker::Name.name)
    10.times do |j|
      Book.create!(title: Faker::Book.title, hard_copies: Faker::Number.between(from: 1, to: 10), author: author)
    end
 end

 p "Created #{Author.count} Authors"
 p "Created #{Book.count} Books"


 #Make out of stock 
loan_users = User.where(user_type_id: member_id).first(3)
author1 = Author.create!(name: Faker::Name.name)
book1 = Book.create!(title: Faker::Book.title, hard_copies: 3, author: author1)
loan_users.each do |user|
    Loan.create!(user: user, book: book1, is_returned: false)
end

#5 users booking 5 books
loan_users = User.where(user_type_id: member_id).take(5)
loan_books = Book.take(5)
loan_users.each_with_index do |user, index|
    Loan.create!(user: user, book: loan_books[index], is_returned: false)
end

p "Created #{Loan.count} Loans"