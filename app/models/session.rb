class Session
  include Mongoid::Timestamps
  include Mongoid::Document

  has_many :breaches
  has_and_belongs_to_many :people
  belongs_to :subject

  field :is_coded, type: Boolean
  field :is_completed, type: Boolean
  field :length, type: Integer
  field :order, type: Integer
  field :time, type: DateTime
end

