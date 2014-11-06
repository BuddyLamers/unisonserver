class Student < Person
  has_many :conferences
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :class_groups

  field :section, type: String

  def self.section_list
    Student.all.distinct(:section)
  end

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      deleted_at: deleted_at.to_i,
      fname: fname,
      lname: lname,
      school: school,
      section: section
    }
  end
end

