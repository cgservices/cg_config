Gem::Specification.new do |gem|
  gem.authors       = ['Luis Doubrava']
  gem.email         = ['luis@cg.nl']
  gem.description   = 'CG Config'
  gem.summary       = 'Gem to add config files as yml'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'cg_config'
  gem.require_paths = ['lib']
  gem.version       = "0.0.7"

  gem.add_development_dependency('rake', ['>= 0'])
  gem.add_development_dependency('rspec', ['>= 0'])
end
