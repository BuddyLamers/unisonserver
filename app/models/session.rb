class Session
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Realization

  has_many :breaches
  has_and_belongs_to_many :people, inverse_of: nil
  belongs_to :subject

  field :is_coded, type: Boolean
  field :is_completed, type: Boolean
  field :length, type: Integer
  field :order, type: Integer
  field :time, type: DateTime

  def as_json(options)
    {
      id: id,
      updated_at: updated_at.to_i,
      created_at: created_at.to_i,
      deleted_at: deleted_at.to_i,
      is_coded: is_coded,
      is_completed: is_completed,
      length: length,
      order: order,
      people: people.map(&:id),
      subject: subject.andand.id
    }
  end

  def update_with_ios_json(hash)
    self.update_attributes(hash[:session])

    if (hash[:breaches])
      hash[:breaches].each do |breach_hash|
        breach = Breach.create_or_update_with_ios_json(breach_hash)
        breach.session = self
        breach.save
      end
    end
  end
end

