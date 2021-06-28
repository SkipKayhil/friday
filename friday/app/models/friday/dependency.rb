# frozen_string_literal: true

module Friday
  # A library/package that is depended on
  class Dependency
    # A specific version of a Dependency
    class Versioned
      class << self
        def from_redis(key, criticality_score)
          vulnerability_status = CRITICALITIES[criticality_score]

          language, name, version = parse_key(key)

          new(Dependency.new(language, name), version, vulnerability_status)
        end

        def parse_key(key)
          # I think the dependency name will have to be base64 encoded because java
          # dependencies appear to have : in the name
          key.split(':')
        end
      end

      attr_reader :dependency, :version

      delegate :language, :name, to: :@dependency

      def initialize(dependency, version, vulnerability_status = nil)
        @dependency = dependency
        @version = version
        @vulnerability_status = vulnerability_status
      end

      def dependents
        Friday.redis.zrange(dependents_key, 0, -1)
      end

      def vulnerability_status
        @vulnerability_status ||= CRITICALITIES[criticality_index]
      end

      def add_app(id)
        criticality_score = CRITICALITIES.index(vulnerability_status)

        Friday.redis.zadd('dependencies', 0, dependency.to_s)
        Friday.redis.zadd('vulnerabilities', criticality_score, to_s)
        Friday.redis.zadd(dependency.versions_key, 0, version)
        Friday.redis.zadd(dependents_key, 0, id.to_s)
      end

      def remove_app(id)
        script = <<-LUA
          redis.call("ZREM", KEYS[1], ARGV[1])

          if redis.call("EXISTS", KEYS[1]) == 1 then return end

          redis.call("ZREM", KEYS[2], ARGV[2])
          redis.call("ZREM", "vulnerabilities", ARGV[3])

          if redis.call("EXISTS", KEYS[2]) == 1 then return end

          redis.call("ZREM", "dependencies", ARGV[4])
        LUA

        Friday.redis.eval(
          script,
          [dependents_key, dependency.versions_key],
          [id.to_s, version, to_s, dependency.to_s]
        )
      end

      def to_hash
        @dependency.as_json.merge!(
          version: @version,
          vulnerability_status: @vulnerability_status
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

      CRITICALITIES = %i[none low medium high critical].freeze

      def criticality_index
        # Ignore git commit versions for now so the whole thing doesn't fail
        return 0 unless version.include?('.')

        gem = Gem::Specification.new(name, version)

        Friday::RubyDB.check_gem(gem).reduce(0) do |score, advisory|
          advisory_score = CRITICALITIES.index(advisory.criticality.presence || :medium)

          return advisory_score if advisory.criticality == :critical

          [score, advisory_score].max
        end
      end
    end

    class << self
      def all
        Friday.redis.zrange('dependencies', 0, -1).map do |key|
          from_key(key)
        end
      end

      def for(dependencies_key)
        dependencies = zinter(dependencies_key)

        dependencies.map do |key, vulnerability_score|
          dep = Versioned.from_redis(key, vulnerability_score)

          [dep.name, dep]
        end.to_h
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

      def parse_key(key)
        # I think the dependency name will have to be base64 encoded because java
        # dependencies appear to have : in the name
        key.split(':')
      end

      def zinter(key)
        native_zinter = Friday.redis.info['redis_version'].starts_with?('6.2'))

        if native_zinter
          Friday.redis.zinter(key, 'vulnerabilities', with_scores: true)
        else
          vulnerability_scores = Friday.redis.zrange('vulnerabilities', 0, -1, with_scores: true).to_h

          Friday.redis.zrange(key, 0, -1).map { |v| [v, vulnerability_scores[v]] }
        end
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
      Friday.redis.zrange(versions_key, 0, -1)
    end

    def with_dependents
      as_json.merge!({ versions: versions.index_with { |v| at(v).dependents.map(&:to_i) } })
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
