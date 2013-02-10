class Contribution
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :person
  belongs_to :breach

  field :text, type: String
  field :time, type: DateTime
end

