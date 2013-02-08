class Student < Person
  has_many :conferences

  field :section, type: String
end

