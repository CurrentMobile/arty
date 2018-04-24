Gem::Specification.new do |s|
  s.name        = "arty"
  s.version     = "0.0.2"
  s.date        = "2018-04-24"
  s.summary     = "Arty"
  s.description = "A tool to generate montage images for album art"
  s.authors     = ["Kiran Panesar"]
  s.email       = "nick@current.us"
  s.files       = ["lib/arty.rb"]
  s.homepage    = "http://rubygems.org/gems/arty"
  s.license     = "MIT"
  s.add_runtime_dependency 'httparty', '~> 0.13.7'
  s.add_runtime_dependency 'rmagick', '~> 2.16'
  s.add_runtime_dependency 'jaro_winkler', '~> 1.4'
end
