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

  module RubyDB
    extend self

    delegate :check_gem, to: :database

    private

    def database
      @ruby_db ||= begin
        if Bundler::Audit::Database.exists?
          Bundler::Audit::Database.update!
        else
          Bundler::Audit::Database.download
        end

        Bundler::Audit::Database.new
      end
    end
  end
end
