require 'lib/melon'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/html'], :root => 'public'
use Rack::ShowExceptions
use Rack::Session::Cookie

# Run application
run Melon::Server.new