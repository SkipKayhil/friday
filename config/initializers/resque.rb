# frozen_string_literal: true

Redis.current = Redis.new(logger: Rails.logger)
Resque.redis = Redis.current
