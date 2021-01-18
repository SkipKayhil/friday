# frozen_string_literal: true

module Dep
  # Configuration object used to initialize wrappers
  class Config
    attr_accessor :source, :parser, :fetcher, :credentials, :package_manager

    def initialize(source: nil, parser: nil, fetcher: nil, credentials: nil, package_manager: nil)
      @source = source
      @parser = parser
      @fetcher = fetcher
      @credentials = credentials
      @package_manager = package_manager
    end
  end
end
