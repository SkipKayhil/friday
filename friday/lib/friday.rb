# frozen_string_literal: true

require "resolv-replace"
require "dependabot/bundler"
require "dependabot/gradle"
require "dependabot/maven"
require "bundler/audit"
require_relative "./friday/version"
require_relative "./friday/engine"
require_relative "./friday/dbot_runner"

module Friday
  module_function

  def redis
    @redis ||= Redis.new(
      db: Rails.env.test? ? 1 : 0,
      logger: Rails.logger
    )
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
