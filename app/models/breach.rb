class Breach
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :session
  has_and_belongs_to_many :people
  has_and_belongs_to_many :codes
  has_many :contributions

  field :time, type: DateTime
  field :type, type: String
end

