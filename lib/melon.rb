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
  VERBOSE = true
  
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
              split('.')[0].          # Drop .json
              split('/').
              reject { |i| i.empty? } # Clear empty strings
      
      route.shift if route.first == 'm' # Drop /m/ if necessary
      
      # Make sure request was an XHR, and the route is valid
      if route.size >= 2 && @request.xhr?
        if Melon.const_defined? route.first.capitalize
          r *route
        else
          puts route.first.capitalize + " doesnt exist!"
          r :error, :module, route.first.capitalize
        end
      else
        r :error, :routing
      end
      
      say
      say "* Path: #@module/#@action/#@key" + " <= " + path
      
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
      
      @output = controller.do( @action )
      (@session <= @output[:session]).save!
      @response.body = @output[:content].to_json
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
  def self.[](const) self.const_get( const ) end
  def [](const) self.const_get( const ) end
  
  def null() nil.to_json end
  def say s = ''
    puts s if Melon::VERBOSE
  end
end
class String; alias each each_line end
class Array
  def second; self[1] end
  def third;  self[2] end
end
