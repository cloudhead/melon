module Melon
  module Error
    class Controller < Base::Controller
      def routing
        return :error => "Routing error!"
      end
      
      def module m
        return :error => "Module '#{m}' doesn't exist!"
      end
    end
  end
end