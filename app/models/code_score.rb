class CodeScore
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :conference
  belongs_to :code

  field :comment, type: String
  field :score, type: Integer

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      comment: comment,
      score: score,
      code: code.andand.id,
      conference: conference.andand.id
    }
  end
end

