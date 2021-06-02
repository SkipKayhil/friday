# frozen_string_literal: true

module Friday
  # A library/package that is depended on
  class Dependency
    # A specific version of a Dependency
    class Versioned
      attr_reader :dependency, :version

      delegate :language, :name, to: :@dependency

      def initialize(dependency, version)
        @dependency = dependency
        @version = version
      end

      def dependents
        Redis.current.zrange(dependents_key, 0, -1)
      end

      def add_app(id)
        Redis.current.zadd(dependency.deps_for_language_key, 0, name)
        Redis.current.zadd(dependency.versions_key, 0, version)
        Redis.current.zadd(dependents_key, 0, id.to_s)
      end

      def remove_app(id)
        script = <<-LUA
          redis.call("ZREM", KEYS[1], ARGV[1])

          if redis.call("EXISTS", KEYS[1]) == 1 then return end

          redis.call("ZREM", KEYS[2], ARGV[2])

          if redis.call("EXISTS", KEYS[2]) == 1 then return end

          redis.call("ZREM", KEYS[3], ARGV[3])
        LUA

        Redis.current.eval(
          script,
          [dependents_key, dependency.versions_key, dependency.deps_for_language_key],
          [id.to_s, version, name]
        )
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
      def all
        all_deps_for_language('ruby').map do |name|
          new('ruby', name)
        end
      end

      def from_key(key)
        language, name, version = parse_key(key)

        if version.nil?
          new(language, name)
        else
          new(language, name).at(version)
        end
      end

      private

      def all_deps_for_language(language)
        Redis.current.zrange("dependencies:#{language}", 0, -1)
      end

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

    def versions
      Redis.current.zrange(versions_key, 0, -1)
    end

    def to_s
      "#{language}:#{name}"
    end

    def ==(other)
      self.class == other.class && to_s == other.to_s
    end

    def deps_for_language_key
      "dependencies:#{language}"
    end

    def versions_key
      "#{self}:versions"
    end
  end
end
