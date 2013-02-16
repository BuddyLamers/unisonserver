class CodeScore
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :conference
  belongs_to :code

  field :comment, type: String
  field :score, type: Integer
end

