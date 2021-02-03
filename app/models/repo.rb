# frozen_string_literal: true

# A git repository
class Repo < ApplicationRecord
  belongs_to :host

  delegated_type :repoable, types: %w[App Library]

  scope :depends_on, ->(name) { where('(dependencies -> ?) is not null', name) }

  def update_dependencies
    fetcher = Dep::Source.new(repo: self, host: host).fetcher
    parser = fetcher.parser

    self.ruby_version = fetcher.parse_ruby_version.match(/\d+\.\d+\.\d+/)
    self.dependencies = parse_dependencies(parser)

    save
  end

  private

  def parse_dependencies(parser)
    parsed_deps = {}
    parser.get.parse.each do |dep|
      parsed_deps[dep.name] = { version: dep.version }
    end

    parsed_deps
  end
end
