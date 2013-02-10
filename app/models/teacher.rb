class Teacher < Person
  has_many :conferences

  def as_json(options)
    {
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      fname: fname,
      lname: lname,
      school: school
    }
  end
end

