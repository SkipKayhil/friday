# frozen_string_literal: true

# A library/package that is depended on
Dependency = Struct.new(:language, :name, :version) do
  class << self
    def from_key(key:, language:)
      name, version = parse_key(key)
      new(language, name, version)
    end

    private

    def parse_key(key)
      # I think the dependency name will have to be base64 encoded because java
      # dependencies appear to have : in the name
      key.split(':')
    end
  end

  def dependents
    Redis.current.zrange(apps_key, 0, -1)
  end

  def add_app(id)
    Redis.current.zadd(apps_key, 0, id.to_s)
  end

  def remove_app(id)
    Redis.current.zrem(apps_key, id.to_s)
  end

  def to_value
    "#{name}:#{version}"
  end

  private

  def apps_key
    "#{language}:#{name}:#{version}:apps"
  end
end
