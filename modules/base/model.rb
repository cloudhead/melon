module Melon
  module Base
    class Model
      attr_reader :doc
    
      @has = nil
      @belongs = ''
      @key = :id
  
      #
      # Set the key to `value`
      #
      def initialize( doc = {} )
    
        if doc.is_a? Document # From response object
          @doc = doc
        else                  # New document
          @doc = Document.new
          self.is = self.class.to_s.downcase.split('::').first
      
          # Send the values through the attribute= functions
          doc.each do |k, v|
            send( k.to_s + '=', v ) 
          end
        
          puts "* Setting default values..."
          # Set defaults on missing values
          self.class.has.each do |k, v|
            send( k.to_s + '=', v ) unless @doc[ k ]
          end
          puts "* New #{ self.class }: " + @doc.inspect
          @doc[:id] = id
        end
    
        self
      end
  
      def id
        @doc.id || send( self.class.key ).downcase.gsub(/[^a-z0-9]+/i, '-')
      end
  
      def is= a
        @doc.is = a
      end
  
      #
      # Accessor methods
      #
      # Define how the model hierarchy will be traversed
      #
      class << self
        def has( has = nil )
          @has = has || @has
        end
    
        def key
          has.keys.first
        end
    
        def get id
          self.new( Sky.get( id ) )
        end
      end
  
      def to_json
        @doc.to_json
      end
  
      #
      # If the method isn't found, look in @doc
      #
      def method_missing *args
        print "* super: Method :#{ args.first } not found, looking in @doc... "
        if args.first.to_s =~ /=$/
          puts "setting to #{args.last}"
          @doc[ args.first.to_s.chop.intern ] = args.last
        else # CASE
          puts @doc[ args.first ]
          @doc[ args.first ]
        end
      end
    end
  end
end