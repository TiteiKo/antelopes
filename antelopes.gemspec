Gem::Specification.new do |s|
  s.name        = 'antelopes'
  s.version     = '0.0.0'
  s.date        = '2017-04-06'
  s.summary     = 'Nice and smart background jobs'
  s.authors     = ['Marion Duprey']
  s.email       = 'titeiko@gmail.com'
  s.files       = ['lib/antelopes.rb']
  s.homepage    = 'https://github.com/titeiko/antelopes'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency 'serverengine', '~> 2'

  s.add_development_dependency 'rake', '> 0'
  s.add_development_dependency 'minitest', '> 0'
end
