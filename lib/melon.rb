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
  class Server
    def initialize
      puts "*"
      puts "* Initializing Melon..."
      puts "* Ruby " + RUBY_VERSION
    
      raise "Melon needs ruby 1.9.1 or higher!" if RUBY_VERSION < '1.9.1'  
    end
  
    # Called on each request
    def call env           
      Router.new( env ).go.finish
    end
  end
  
  class Router
    def initialize env
      @request  = Rack::Request.new env
      @response = Rack::Response.new
      @session, path, @input = Session.new( @request.env['rack.session'] ), 
                               @request.path_info,
                               @request.params
      
      # Parse route from url
      route = path.
              split('/').
              reject { |i| i.empty? }. # Clear empty strings
              drop(1)                  # Remove /m/
      
      # Make sure request was an XHR, and the route is valid
      if route.size >= 2 && @request.xhr?
        if defined? route.first.capitalize
          r *route
        else
          r :error, :module
        end
      else
        r :error, :route
      end
      
      #puts
      #puts "* Path: #@module/#@action/#@key"
      
      self
    end
    
    def r *args
      @module, @action, @key = *args
    end
    
    
    #
    # Create controller object & call action
    #
    def go
      controller = Melon[ @module.capitalize ]::Controller.new( @key, @input, @session )
      
      if controller.respond_to? @action
        @output = controller.do( @action )
        (@session <= @output[:session]).save!
        @response.body = @output[:content].to_json
      else
        
      end
      @response['Content-Length'] = @response.body.size.to_s
      @response['Content-Type'] = 'application/json'
      
      @response
    end
  end
  
  class Document < Hash
  end
end

class Object
  # Syntactic sugar for const_get()  
  def self.[]( const )
    self.const_get( const )
  end
  
  # For modules
  def []( const )
    self.const_get( const )
  end
  
  def null
    nil.to_json
  end
end

class String
  alias each each_line
end

class Array
  def second; self[1] end
  def third;  self[2] end
end
