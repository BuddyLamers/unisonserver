class Code
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :subject
  belongs_to :code_type

  field :name, type: String
  field :year, type: Integer

  validates_presence_of :code_type, :name, :subject
  validates_uniqueness_of :name, scope: :subject && :code_type

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

