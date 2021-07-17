# frozen_string_literal: true

module Dep
  Artifacts = Struct.new(:package_manager, :credentials, :source, :fetcher)
end
