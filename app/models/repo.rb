# frozen_string_literal: true

# A git repository
class Repo < ApplicationRecord
  def update_dependencies
    parser = Dep::Source.new(repo: full_path, directory: directory).fetcher.parser
    lockfile = parser.get.send(:lockfile).content

    self.ruby_version = parse_ruby_version(lockfile)
    self.dependencies = parse_dependencies(parser)

    save
  end

  private

  def parse_ruby_version(lockfile)
    Bundler::LockfileParser.new(lockfile).ruby_version.match(/\d+\.\d+\.\d+/)
  end

  def parse_dependencies(parser)
    parsed_deps = {}
    parser.get.parse.each do |dep|
      parsed_deps[dep.name] = { version: dep.version }
    end

    parsed_deps
  end
end
