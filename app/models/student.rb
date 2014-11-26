class Student < Person
  has_many :conferences
  has_many :code_scores
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :sessions

  field :section, type: String

  def self.section_list
    Student.all.distinct(:section)
  end

  def code_types_counts
    breach_types = {}
    CodeType.each do |type|
      breach_types[type.name] = 0
    end
    self.breaches.includes(:code_type).each do |breach|
      current_type = breach.code_type.name
      breach_types[current_type] += 1
    end
    breach_types
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

