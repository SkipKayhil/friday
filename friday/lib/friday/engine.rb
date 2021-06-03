# frozen_string_literal: true

module Friday
  class Engine < ::Rails::Engine
    isolate_namespace Friday
    config.generators.api_only = true
  end
end
