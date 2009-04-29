module Melon
  module Base
    class Controller
      attr_reader :session
  
      def initialize( key = nil, params = {}, session )
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
        return :content => @key ? send( action, @key ) : send( action ), 
               :session => @session
      end
  
      def method_missing *args
        return :error => args.first.to_s + " is not an action!"
      end
    end
  end
end