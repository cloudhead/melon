module Melon
  module Session
    def self.new *args
      Session::Model.new *args
    end
  
    class Model < Hash
      def initialize session = {}
        @env = session #unless session.empty?
    
        self[:auth] = false
        self[:failed] = 0
    
        self << session if session
    
        self
      end
  
      # Copy a hash into the session
      def merge s
        s.each do |k, v|
          self[ k ] = v
        end
      end
      alias << merge
      
      def merge! s
        merge s
        save!
      end
    
      def god?
        self[:god]
      end
  
      def god= bool
        self[:god] = bool
      end
  
      def name
        self[:name]
      end
  
      def login name = nil
        self[:auth] = true
        self[:name] ||= name
        self
      end
  
      # Delete all cookies
      def logout
        self.each do |k,|
          self.delete k
        end
        self
      end
  
      # Write session to env
      def save!
        @env.replace self
      end
  
    end

    class Controller < Base::Controller
      def create
        unless @input.empty?
          say "* " + @input['name'] + " is logging in..."
          user = Sky.get @input['name']
      
          if @input['password'] == thinker['password']
            # Login
            @session.login @input['name']        
            @session.god = @input['name'] == Settings.cloudder.god ? true : false
          else
            @session[:auth] = false
            @session[:failed] += 1
          end
        end
        return :session => @session, :redirect => self./
      end
  
      def new
        return :session => @session
      end
  
      def destroy
        return :session => @session.logout
      end
  
      def method_missing *args
        super
      end
    end
  end
end