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

# need one teacher to create one admin
Teacher.create(fname: "Example", lname: "Teacher", school: "Unison")

User.create!(email: "BuddyLamers@gmail.com", password: "unison", password_confirmation: "unison", role: :admin )