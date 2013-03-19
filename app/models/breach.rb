class Breach
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :session
  has_and_belongs_to_many :people
  has_and_belongs_to_many :codes
  has_many :contributions

  field :time, type: DateTime
  field :type, type: String

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      time: time.to_i,
      type: type
    }
  end
end

