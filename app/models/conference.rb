class Conference
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  has_many :code_scores
  belongs_to :student
  belongs_to :teacher
  belongs_to :subject

  field :is_completed, type: Boolean
  field :notes, type: String
  field :time, type: DateTime

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      is_completed: is_completed,
      student: student.andand.id,
      teacher: teacher.andand.id,
      codeScores: code_scores,
      subject: subject.andand.id
    }
  end
end

