# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'antelopes'
  s.version     = '0.0.1'
  s.summary     = 'Nice and smart background jobs'
  s.authors     = ['Marion Duprey']
  s.email       = 'titeiko@gmail.com'
  s.files       = `git ls-files | grep -Ev '^(bin|test)'`.split("\n")
  s.homepage    = 'https://github.com/titeiko/antelopes'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency 'connection_pool', '~> 2'
  s.add_runtime_dependency 'redis', '~> 3'
  s.add_runtime_dependency 'serverengine', '~> 2'

  s.add_development_dependency 'minitest', '> 0'
  s.add_development_dependency 'minitest-reporters', '> 0'
  s.add_development_dependency 'rake', '> 0'
  s.add_development_dependency 'pry', '> 0'
end
