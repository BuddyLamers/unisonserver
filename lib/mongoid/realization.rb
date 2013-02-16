module Mongoid
  module Realization
    class << self
      def realize(id)
        begin
          self.find(id)
        rescue
          object = self.new
          object.id = id
          object
        end
      end
    end
  end
end

