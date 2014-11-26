class Breach
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Realization

  belongs_to :session
  belongs_to :code_type
  has_and_belongs_to_many :people, inverse_of: :breaches
  has_and_belongs_to_many :codes, inverse_of: nil
  has_many :contributions

  field :time, type: DateTime

  def breacher
    self.contributions.first.person
  end

  def has_contributed(person)
    
  end

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      deleted_at: deleted_at.to_i,
      time: time.to_i,
      contributions: contributions,
      session: session.andand.id,
      codeType: code_type.andand.id
    }
  end
end

