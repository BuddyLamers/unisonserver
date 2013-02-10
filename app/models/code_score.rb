class CodeScore
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :conference
  belongs_to :code

  field :comment, type: String
  field :score, type: Integer
end

