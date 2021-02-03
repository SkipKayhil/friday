# frozen_string_literal: true

# Delegated Type for Models that extend Repo
module Repoable
  extend ActiveSupport::Concern

  included do
    has_one :repo, as: :repoable, touch: true, dependent: :destroy
    accepts_nested_attributes_for :repo
  end
end
