class Conference
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :code_scores
  belongs_to :student
  belongs_to :teacher
  belongs_to :subject

  field :is_complete, type: Boolean
  field :notes, type: String
  field :time, type: DateTime
end

