class Code
  include Mongoid::Document

  field :name, type: String
  field :type, type: String
  field :year, type: Integer
end

