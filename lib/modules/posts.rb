module Melon
  module Posts
    class Model < Base::Model
    end
    
    class Controller < Base::Controller
      
      ## Front Page
      # 
      # Gets the [key] most recent posts, ordered by date
      #
      def frontpage key = 0
        key = key.to_i - 1 # This takes care of an omitted `key` value
        Dir.chdir("htdocs/json/posts") do
          Dir.new( Dir.pwd ).entries.reverse[0..key].collect do |f|
            if File.file?(f) && f =~ /.json$/
              JSON.parse( File.read( f ) )     
            end
          end.compact
        end
      end
      
    end
  end
end