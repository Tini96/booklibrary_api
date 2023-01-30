# README


## Ruby version

ruby "3.1.3"

## Dependencies

rails  "7.0.4"

sqlite3 ""1.4.0"

## Configuration

Prerequirements: ruby, rails and sqlite3
Install all gems

```
bundle install
```

## Database creation

Create database and  run migrations.

```
rake db:create
rake db:migrate
```
 

## Database initialization

Populate database with some dummy data.

```
rails db:seed
```
## Run server

```
rails s
```

## API
When creating a new user, you first need to find the user type id (2 types: Librarian and Member)
```
GET /user_type
```
Then register a new user with chosen user_type_id from previous response
```
POST /register
```
After registration, the user logs in with email and password
```
POST auth/login
```

### Members
they are allowed to:

* search books and authors by term parametar

```
GET /books
GET /authors
```

* see all their loans
```
GET /loans
```

### Librarians
they are allowed to:

* search, update, delete users, authors and books (add books and authors)

```
GET/PUT/POST/DELETE /users
GET/PUT/POST/DELETE /authors
GET/PUT/POST/DELETE /books
```

* search, update, add, delete loans and see which books are out of stock

```
GET/PUT/POST/DELETE /loans
GET /out-of-stock
```

## Testing

create and migrate test database

```
rake db:create RAILS_ENV=test
rake db:migrate RAILS_ENV=test
```
Populate test database with fixtures

```
rails db:fixtures:load RAILS_ENV=test
```

### Model tests:
```
rails test test/models/loan_test.rb

rails test test/models/user_test.rb
```

### Integration test:
```
rails test test/integration/loans_test.rb
```