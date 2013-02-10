class Code
  include Mongoid::Document
  include Mongoid::Timestamps

  field :updated_at, type: Integer
  field :name, type: String
  field :type, type: String
  field :year, type: Integer
end

