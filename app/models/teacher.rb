class Teacher < Person

  has_many :conferences
  has_many :sessions
  has_and_belongs_to_many :students
  has_many :class_groups

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      deleted_at: deleted_at.to_i,
      fname: fname,
      lname: lname,
      school: school,
      students: students.map(&:id)
    }
  end
end

