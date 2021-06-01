# frozen_string_literal: true

# A git repository
class Repo < ApplicationRecord
  belongs_to :host

  delegated_type :repoable, types: %w[App Library]

  scope :depends_on, ->(name) { where('(dependencies -> ?) is not null', name) }
end
