# Ruby
require 'rack'
require 'date'
require 'digest'
require 'json'

$:.unshift File.dirname(__FILE__)

# Load modules
Dir.chdir('lib/modules') do
  puts '* Opening modules/'
  require 'base/model'
  require 'base/controller'
  Dir.new('.').entries.each do |f| 
    if File.file?( f ) && f =~ /.rb$/
      puts '* Found ' + f
      require f
    end
  end
end

module Melon
  Verbose = true
  #
  # Server
  #
  class Server
    def initialize
      puts "*"
      puts "* Initializing Melon..."
      puts "* Ruby " + RUBY_VERSION
    
      raise "Melon needs ruby 1.9.1 or higher!" if RUBY_VERSION < '1.9.1'  
    end
  
    # Called on each request
    def call env           
      @request  = Rack::Request.new env
      @response = Rack::Response.new

      if @request.xhr? # Request has to be XHR, no fucking around
        @session = Session.new( @request.env['rack.session'] )
        @route   = Route.new @request.path_info 
        
        say
        say @route.to_s
        
        @output = @route.go @request.params, @session # Process the request
        @session.merge!  @output[:session] # Merge and save!
        @response.body = @output[:content].to_json
      else
        @response.body = { error: "request must be xhr!" }.to_json
      end
      
      @response['Content-Length'] = @response.body.size.to_s
      @response['Content-Type'] = 'application/json'
      @response.finish
    end
  end
  
  #
  # Router
  #
  class Route
    attr_reader :module, :action, :key

    def initialize path
      @path = path
      @route = @path
               .split('.').first.split('/')    # Drop .json and split at /
               .reject {|i| i.empty? }[1..-1]  # Clear empty strings and drop [0]
      self
    end

    def to route
      @module, @action, @key = *route
    end
    
    def go input, session
      mod = @route.first.capitalize
      
      # Check for errors
      to (if ! Melon.const_defined? mod
            [:error, :module, mod]
          elsif ! (2..3) === @route.size
            [:error, :route]
          else
            @route
          end)
       
      # Create a new controller, based on the route, then call the action on it
      controller = Melon[ @module.capitalize ]::Controller.new @key, input, session
      controller.do @action
    end

    def to_s
      '/' + @route * '/'
    end
  end
  
  class Document < Hash
  end
end

# CORE CLASSES #

class Object
  # Syntactic sugar for const_get()  
  def self.[](const) self.const_get( const ) end
  def [](const) self.const_get( const ) end
  
  def null() nil.to_json end
  def say s = ''
    puts s if Melon::Verbose
  end
end
class String; alias each each_line end
class Array
  def second; self[1] end
  def third;  self[2] end
end
