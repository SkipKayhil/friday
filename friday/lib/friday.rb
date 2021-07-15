# frozen_string_literal: true

require "resolv-replace"
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
      @database ||= begin
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
