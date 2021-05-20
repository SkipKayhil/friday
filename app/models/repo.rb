# frozen_string_literal: true

# A git repository
class Repo < ApplicationRecord
  belongs_to :host

  delegated_type :repoable, types: %w[App Library]

  scope :depends_on, ->(name) { where('(dependencies -> ?) is not null', name) }

  def update_dependencies
    parser = Dep::Source.new(repo: self, host: host).fetcher.parser

    self.ruby_version = parser.ruby_version.match(/\d+\.\d+\.\d+/)
    self.dependencies = parser.dependencies

    save
  end
end
