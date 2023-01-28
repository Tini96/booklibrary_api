UserType.destroy_all
UserType.create([{
    type_name: "Member"
},
{
    type_name: "Librarian"
}])
p "Created #{UserType.count} UserTypes"