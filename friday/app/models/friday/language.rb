# frozen_string_literal: true

module Friday
  # A programming language that dependabot can parse dependencies of
  class Language
    def self.for_package_manager(package_manager)
      case package_manager
      when "bundler"
        "ruby"
      when "maven", "gradle"
        "java"
      when "npm_and_yarn"
        "javascript"
      else
        raise "Unsupported package manager: #{package_manager}"
      end
    end
  end
end
