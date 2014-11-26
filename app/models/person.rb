class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Realization

  has_one :user
  has_and_belongs_to_many :breaches, inverse_of: :people, class_name: 'Breach', foreign_key: :breach_ids
  has_many :sessions
  has_many :contributions

  field :fname, type: String
  field :lname, type: String
  field :school, type: String


def self.find_and_sort_by_ids(ids)
  self.find(ids).sort_by{|m| ids.index(m.id) }
end

def breaches_breached
    breached = 0
    self.breaches.each do |breach|
      breached += 1 if breach.contributions[0].person == self
    end
    breached
  end

  def breaches_contributed
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

def name
  "#{fname} #{lname}"
end

end
