# frozen_string_literal: true

require 'dependabot/bundler'
require 'bundler/audit'
require 'friday/version'
require 'friday/engine'

module Friday
  module_function

  def redis
    @redis ||= Redis.new(logger: Rails.logger)
  end
end
