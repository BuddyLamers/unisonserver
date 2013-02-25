class Code
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :subject
  belongs_to :code_type

  field :name, type: String
  field :year, type: Integer

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      name: name,
      year: year,
      subject: subject.andand.id
    }
  end
end

