UserType.destroy_all
UserType.create([{
    type_name: "Member"
},
{
    type_name: "Librarian"
}])
p "Created #{UserType.count} UserTypes"

librarian_id = UserType.find_by_type_name("Librarian").id
member_id = UserType.find_by_type_name("Member").id

User.destroy_all
User.create([{
    name: "Anna",
    username: "anna",
    email: "anna@librarian.com",
    password: "anna321",
    user_type_id: librarian_id
},
{
    name: "Marc",
    username: "marc",
    email: "marc@librarian.com",
    password: "marc321",
    user_type_id: librarian_id
},
{
    name: "Lucas",
    username: "lucas",
    email: "lucas@member.com",
    password: "lucas321",
    user_type_id: member_id
},
{
    name: "Pier",
    username: "pier",
    email: "pier@member.com",
    password: "pier321",
    user_type_id: member_id
},
{
    name: "Leo",
    username: "leo",
    email: "leo@member.com",
    password: "leo321",
    user_type_id: member_id
},{
    name: "Sarah",
    username: "sarah",
    email: "sarah@member.com",
    password: "sarah321",
    user_type_id: member_id
},
{
    name: "Bertha",
    username: "bertha",
    email: "bertha@member.com",
    password: "bertha321",
    user_type_id: member_id
}])

p "Created #{User.count} Users"