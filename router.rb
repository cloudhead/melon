module Melon
  class Router
    def initialize env
      @request  = Rack::Request.new env
      @response = Rack::Response.new
      @session, path, @input = Session.new( @request.env['rack.session'] ), 
                               @request.path_info,
                               @request.params
    
      # Break path into discreet parts & trim slashes    
      route = path.
              split('/').
              reject { |i| i.empty? }.
              drop(1) # Remove /m/
      
      if route.size >= 2 && @request.xhr?
        @module, @action, @key = *route
      else
        @module, @action = :error, :report
      end
      
      puts
      puts "* Path: #@module/#@action/#@key"
      
      self
    end
  
    #
    # Create controller object & call action
    #
    def go
      controller = Melon[ @module.capitalize ]::Controller.new( @key, @input, @session )
      @output = controller.do( @action ) || {}
      (@session <= @output[:session]).save!
      
      @response.body = @output[:content].to_json
      @response['Content-Length'] = @response.body.size.to_s
      @response['Content-Type'] = 'application/json'
      
      @response
    end
  end
end