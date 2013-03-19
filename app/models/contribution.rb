class Contribution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Realization

  belongs_to :person
  belongs_to :breach

  field :text, type: String
  field :time, type: DateTime

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      text: text,
      time: time.to_i,
      person: person.andand.id,
      breach: breach.andand.id
    }
  end
end

