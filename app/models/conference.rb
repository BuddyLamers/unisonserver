class Conference
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Realization

  has_many :code_scores
  has_and_belongs_to_many :students
  has_and_belongs_to_many :people
  belongs_to :teacher
  belongs_to :subject

  field :is_completed, type: Boolean
  field :notes, type: String
  field :time, type: DateTime
  # revised form
  field :breach, type: String
  field :known, type: String
  field :unknown, type: String
  field :resolution, type: String
  field :narrative, type: String
  field :takeaway, type: String

  validates_presence_of :students
  validates_presence_of :teacher
  validates_presence_of :subject

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      deleted_at: deleted_at.to_i,
      is_completed: is_completed,
      student: student.andand.id,
      teacher: teacher.andand.id,
      codeScores: code_scores,
      subject: subject.andand.id,
      time: time.to_i
    }
  end
end

