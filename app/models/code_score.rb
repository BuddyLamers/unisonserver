class CodeScore
  include Mongoid::Document

  belongs_to :conference
  belongs_to :code

  field :comment, type: String
  field :score, type: Integer
end

