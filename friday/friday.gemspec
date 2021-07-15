# frozen_string_literal: true

require_relative 'lib/friday/version'

Gem::Specification.new do |spec|
  spec.name        = 'friday'
  spec.version     = Friday::VERSION
  spec.authors     = ['Hartley McGuire']
  spec.email       = ['skipkayhil@gmail.com']
  spec.homepage    = 'https://github.com/skipkayhil/friday'
  spec.summary     = 'Repository automation'
  spec.description = 'Automate making code changes in git repositories'
  spec.license     = 'GPL-3.0-or-later'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/skipkayhil/friday'
  # spec.metadata['changelog_uri'] = 'TODO: Put your gem's CHANGELOG.md URL here.'

  spec.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'bundler-audit', '~> 0.8'
  spec.add_dependency 'dependabot-bundler', '~> 0.149'
  spec.add_dependency 'rails', '~> 6.1.3', '>= 6.1.3.2'
  spec.add_dependency 'redis', '~> 4.2', '>= 4.2.5'
  spec.add_dependency "resolv-replace", "~> 0.1"
end
