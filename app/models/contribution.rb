class Contribution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :person
  belongs_to :breach

  field :text, type: String
  field :time, type: DateTime
end

