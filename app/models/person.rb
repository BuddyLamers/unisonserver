class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Realization

  has_one :user
  has_and_belongs_to_many :breaches, inverse_of: :people, class_name: 'Breach', foreign_key: :breach_ids
  has_many :sessions
  has_many :contributions
  has_and_belongs_to_many :conferences

  field :fname, type: String
  field :lname, type: String
  field :school, type: String


  def self.find_and_sort_by_ids(ids)
    self.find(ids).sort_by{|m| ids.index(m.id) }
  end

  def breaches_breached
    breached = 0
    self.breaches.each do |breach|
      breached += 1 if breach.contributions[0].person == self && breach.session.is_completed == true
    end
    breached
  end

  def breaches_contributed
    count = 0
    breaches = self.breaches.includes(:contributions)
    self.contributions.each do |contribution|
      breaches.each do |breach|
        if breach.contributions.include?(contribution) && breach.session.is_completed == true
          count += 1
          next
        end
      end
    end
    count
  end

  def total_breaches
    breach_count = 0
   Breach.where(person_ids: {"$in" => [self.id]}).each do |breach| 
    breach_count += 1 if Session.find(breach.session_id).is_completed == true 
    end 
    return breach_count
  end

  def conference_standard_counts
    standard_counts = {}
    standard_counts.default = 0
    Conference.where(person_ids: {"$in" => [self.id]}).each do |conference|
        standard_counts[conference.subject.name] +=1
    end
    standard_counts
  end

def name
  "#{fname} #{lname}"
end

end
