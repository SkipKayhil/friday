# frozen_string_literal: true

class App < ApplicationRecord
  include Repoable

  def language
    Friday::Language.for_package_manager(package_manager)
  end

  def dependencies
    @dependencies ||= Friday::App::Dependencies.new(self)
  end

  # Hard coding this for now but it'll be a field on the db later
  def package_manager
    "bundler"
  end

  def attributes
    h = super
    h['dependencies'] = nil
    h
  end
end
