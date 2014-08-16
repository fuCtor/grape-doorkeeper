$:.push File.expand_path("../lib", __FILE__)
require "grape-doorkeeper/version"

Gem::Specification.new do |s|
  s.name        = "grape-doorkeeper"
  s.version     = GrapeDoorkeeper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alexey Shcherbakov"]
  s.email       = ["schalexey@gmail.com"]
  s.homepage    = "https://github.com/fuCtor/grape-doorkeeper"
  s.summary     = %q{Gem for auth in grape via doorkeeper.}
  s.description = %q{Gem for auth in grape via doorkeeper.}
  s.license     = "MIT"

  s.rubyforge_project = "grape-doorkeeper"

  s.add_runtime_dependency 'grape', '~> 0.6'
  s.add_runtime_dependency 'doorkeeper', '~> 0'
    
  s.add_development_dependency 'rack-test', '~> 0'
  s.add_development_dependency 'rspec', '~> 2.9'
  s.add_development_dependency 'bundler', '~> 0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
