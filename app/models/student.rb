class Student < Person
  has_and_belongs_to_many :conferences
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
      next if breach.code_type.nil?
      current_type = breach.code_type.name
      breach_types[current_type] += 1
    end
    breach_types
  end

# TODO working on creating stats by standards
#On the CUR section you were able to view how many times a specific type of breach occurred, 
#could we have the same feature but rather than the breach, 
#have it be a tally of the standards that happened in a conference for each individual kid?
  def standards_counts
    standards = {}
    standards.default(0)

    self.breaches.each do |b|
      standards[b.subject] += 1
    end
    return standards
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

