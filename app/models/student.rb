class Student < Person
  has_many :conferences
  has_many :code_scores
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :sessions

  field :section, type: String

  def self.section_list
    Student.all.distinct(:section)
  end

  def breaches_breached
    breached = 0
    self.breaches.each do |breach|
      breached += 1 if breach.contributions[0].person == self
    end
    breached
  end

  def breaches_contributed
    # contributed = 0
    # contributions = self.contributions
    # self.breaches.includes(:contribution).each do |breach|
    #    contributions.each do |contribution|
    #     if condition
          
    #     end
    #   end
    # end

    count = 0
    breaches = self.breaches.includes(:contributions)
    self.contributions.each do |contribution|
      breaches.each do |breach|
        if breach.contributions.include?(contribution)
          count += 1
          next
        end
      end
    end
    count
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

