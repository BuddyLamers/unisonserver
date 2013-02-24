class Student < Person
  belongs_to :user
  has_many :conferences

  # Ensure that the user object is created before the teacher
  validates_presence_of :user_id
  
  accepts_nested_attributes_for :user, allow_destroy: true

  field :section, type: String

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      fname: fname,
      lname: lname,
      school: school,
      section: section
    }
  end
end

