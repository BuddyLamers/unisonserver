class Subject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  has_many :codes

  field :name, type: String
  
  validates_uniqueness_of :name

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      name: name
    }
  end
end

