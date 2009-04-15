# Ruby
require 'rack'
require 'date'
require 'digest'
require 'json'

$:.unshift File.dirname(__FILE__)

require 'document'
require 'router'

# Load modules
Dir.chdir('lib/modules') do
  puts '* Opening modules/'
  require 'base/model'
  require 'base/controller'
  Dir.new('.').entries.each do |f| 
    unless File.directory?( f )
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
