# frozen_string_literal: true

module Friday
  # An individual project inside a repository
  class Project < ApplicationRecord
    belongs_to :repository

    def language
      Language.for_package_manager(package_manager)
    end

    def dependencies
      @dependencies ||= Dependencies.new(self)
    end

    def attributes
      h = super
      h["language"] = nil
      h["dependencies"] = nil
      h
    end
  end
end
