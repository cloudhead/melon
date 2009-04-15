Gem::Specification.new do |s|
   s.name        = "melon"
   s.version     = "0.1"
   s.date        = Time.today.strftime("%Y-%m-%d")
   s.authors     = ["cloudhead"]
   s.email       = "biopunk@gmail.com"
   s.summary     = "json blog engine"
   s.homepage    = "http://github.com/cloudhead/melon"
   s.description = "minimal blog engine"
   s.files       = [ "README", "bin/prose", "lib/prose.rb"]
   
   s.bindir             = "bin"
   s.default_executable = "melon"
   s.executables        = "melon"
   
   s.add_dependency    "prose",    ">= 0.2"
   s.add_dependency     "json",    ">= 0.2"
   s.add_dependency     "rack",    ">= 0.9"
end