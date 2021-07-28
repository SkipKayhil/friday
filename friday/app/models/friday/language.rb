# frozen_string_literal: true

module Friday
  # A programming language that dependabot can parse dependencies of
  class Language
    def self.for_package_manager(package_manager = :bundler)
      case package_manager
      when :bundler
        "ruby"
      end
    end
  end
end
