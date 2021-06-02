# frozen_string_literal: true

# A library/package that is depended on
class Dependency
  # A specific version of a Dependency
  class Versioned
    attr_reader :version

    delegate :language, :name, to: :@dependency

    def initialize(dependency, version)
      @dependency = dependency
      @version = version
    end

    def dependents
      Redis.current.zrange(dependents_key, 0, -1)
    end

    def add_app(id)
      Redis.current.zadd(dependents_key, 0, id.to_s)
    end

    def remove_app(id)
      Redis.current.zrem(dependents_key, id.to_s)
    end

    def to_s
      "#{@dependency}:#{version}"
    end

    def ==(other)
      self.class == other.class && to_s == other.to_s
    end

    private

    def dependents_key
      "#{self}:apps"
    end
  end

  class << self
    def from_key(key)
      language, name, version = parse_key(key)

      if version.nil?
        new(language, name)
      else
        new(language, name).at(version)
      end
    end

    private

    def parse_key(key)
      # I think the dependency name will have to be base64 encoded because java
      # dependencies appear to have : in the name
      key.split(':')
    end
  end

  attr_reader :language, :name

  def initialize(language, name)
    @language = language
    @name = name
  end

  def at(version)
    Versioned.new(self, version)
  end

  def to_s
    "#{language}:#{name}"
  end

  def ==(other)
    self.class == other.class && to_s == other.to_s
  end

  private

  def apps_key
    "#{to_s}:apps"
  end
end
