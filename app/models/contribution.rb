class Contribution
  include Mongoid::Document

  belongs_to :person
  belongs_to :breach

  field :text, type: String
  field :time, type: DateTime
end

