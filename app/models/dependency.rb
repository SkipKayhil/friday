# frozen_string_literal: true

# A library/package that is depended on
class Dependency
  class << self
    def from_key(key:, language:)
      name, version = parse_key(key)
      new(name: name, version: version, language: language)
    end

    private

    def parse_key(key)
      # I think the dependency name will have to be base64 encoded because java
      # dependencies appear to have : in the name
      key.split(':')
    end
  end

  attr_reader :name, :version

  def initialize(name:, version:, language:)
    @name = name
    @version = version
    @language = language
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
    "#{@name}:#{@version}"
  end

  def ==(other)
    self.class == other.class && _state == other._state
  end

  private

  def apps_key
    "#{@language}:#{@name}:#{@version}:apps"
  end

  protected

  def _state
    [@name, @version, @language]
  end
end
