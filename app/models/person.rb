class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  has_and_belongs_to_many :breaches
  has_and_belongs_to_many :sessions
  has_many :contributions

  field :fname, type: String
  field :lname, type: String
  field :school, type: String
end

