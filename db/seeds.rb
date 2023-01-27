# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
UserType.destroy_all
UserType.create([{
    type_name: "Member"
},
{
    type_name: "Librarian"
}])
p "Created #{UserType.count} UserTypes"