module Melon
  module Error
    class Controller < Base::Controller
      def routing
        return :error => "Routing error!"
      end
      
      def module
        return :error => "Module doesn't exist!"
      end
    end
  end
end