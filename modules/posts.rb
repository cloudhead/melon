module Melon
  module Posts
    class Model < Base::Model
    end
    
    class Controller < Base::Controller
      def frontpage        
        Dir.chdir("public/json/posts") do
          Dir.new( Dir.pwd ).entries.collect do |f|
            if File.file?(f) && f =~ /.json$/
              JSON.parse( File.read( f ) )
            end
          end.compact 
        end
      end
    end
  end
end