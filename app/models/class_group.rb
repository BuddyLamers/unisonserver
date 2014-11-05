class ClassGroup
  # for now is being ignored in favor of student.section
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Realization

  has_and_belongs_to_many :students
  belongs_to :teacher

# may possible bae :name
  field :section, type: String
end
