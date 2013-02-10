module Mongoid
  module Document
    module Updateable
      field :ua, as: :updated_at, type: Integer, default: 0
    end
  end
end

