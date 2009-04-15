module Melon
  module Base
    class Controller
      attr_reader :session
  
      def initialize( key = '', params = {}, session )
        @key = key
        @input = params
        @session = Melon::Session.new( session )
        @response = {}
    
        self
      end
  
      #
      # All the CRUD stuff goes through here
      #
      def do action
        { content: send( action ), session: @session }
      end
  
      def method_missing *args
        { error: args.first + "doesn't exist" }
      end
    end
  end
end