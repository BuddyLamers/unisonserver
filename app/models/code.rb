class Code
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Realization

  belongs_to :subject
  belongs_to :code_type

  field :name, type: String
  field :year, type: Integer
  field :topic, type: String
  field :text, type: String

  validates_presence_of :name, :subject
  validates_uniqueness_of :name, scope: :subject && :code_type

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      deleted_at: deleted_at.to_i,
      name: name,
      text: text,
      year: year,
      subject: subject.andand.id
    }
  end
end

