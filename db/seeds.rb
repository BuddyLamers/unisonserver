# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.create(name: 'BuddyLamers@gmail.com', 
#   ps: "1073b203d021928c1236d5057023de99e1eba45e", 
#   ph: "1073b203d021928c1236d5057023de99e1eba45e",
#   role: :admin)


# REMEMBER: using criteria methods returns a criteria object
# use User.all.to_a to return a meaningful object

# need one teacher to create one superuser
# Teacher.create(fname: "Example", lname: "Teacher", school: "Unison")
my_teacher = Teacher.create(fname: "Buddy", lname: "Lamers", school: "Unison")

my_user = User.create(person_id: my_teacher.id, email: "BuddyLamers@gmail.com", password: "unison", password_confirmation: "unison", role: :super )
# my_teacher.user = User.create(email: "superuser@gmail.com", password: "unison", password_confirmation: "unison", role: :super )
# me.user = my_user
# my_user.person = me

Student.create(fname: "Student", lname: "Number1", school: "unison")
Subject.create(name: "SuperScience")
Code.create(name: "MyCode", year: 6, topic: "Comprehension", text: "MyText")
Code.create(name: "MyCode2", year: 6, topic: "Comprehension2", text: "MyText2")

