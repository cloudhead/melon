module Melon
  module Comments
    class Controller < Base::Controller
      def create
        Dir.chdir('public/json/comments') do
          File.open( @input[:id] + '.json' ) do |f| 
            f.write( ( JSON.parse( f.read ) << { 
              author: @input[:author],
              body: @input[:body],
              date: Time.now.to_i
            }).to_json ) 
          end
        end
      end
    end
  end
end