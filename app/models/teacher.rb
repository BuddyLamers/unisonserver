class Teacher < Person
  belongs_to :user
  has_many :conferences

  accepts_nested_attributes_for :user, allow_destroy: true

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      fname: fname,
      lname: lname,
      school: school
    }
  end
end

