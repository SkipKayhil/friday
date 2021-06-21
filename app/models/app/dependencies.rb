# frozen_string_literal: true

# Things to put in redis:
  # - an App needs a set of dependencies
  #   - key: 'app:1:dependencies:ruby'
  #   - values: 'rails:6.1'
  #     - needs to be intersectable with vulnerability set
  # - a Library needs a set of dependents
  #   - key: 'ruby:rails:6.1:apps'
  #   - values: '1'
  # - a Language needs a _sorted_ set of Library/Versions to vulnerability count
  #   - key: 'ruby:vulnerabilities'
  #   - values: 'rails:5.2.5' '1'
class App
  # Manage an app's dependencies using Redis
  class Dependencies
    # add a fresh dependency
    # - don't need to remove app from old dep list
    # - add '1' to the 'ruby:rails:6.1:apps' list
    # - add 'rails:6.1' to 'app:1:dependencies:ruby' list -> probably update whole list at once

    # update a dependency
    # - remove 'app:1' from the old version of dependency's list
    # - add '1' to new version's list
    delegate :empty?, to: :@dependencies

    def initialize(app)
      @app = app
      @dependencies = Friday::Dependency.for(dependencies_key)
    end

    def update(new_dependencies)
      Friday.redis.multi
      parsed_dependencies = parse_new_dependencies(new_dependencies)
      result = Friday.redis.exec

      @app.touch unless result.empty?

      @dependencies.each_value { |removed_dep| remove_dependency(removed_dep) }

      @dependencies = parsed_dependencies
    end

    def to_hash
      @dependencies.values
    end

    def as_json
      to_hash.as_json(except: 'language')
    end

    private

    def dependencies_key
      "app:#{@app.id}:dependencies"
    end

    def parse_new_dependencies(new_dependencies)
      new_dependencies.map do |dep|
        d = Friday::Dependency.new(@app.language, dep.name).at(dep.version)

        old_version = @dependencies.delete(d.name)

        if old_version != d
          add_dependency(d)
          remove_dependency(old_version) if old_version
        end

        [d.name, d]
      end.to_h
    end

    def add_dependency(dep)
      dep.add_app(@app.id)
      Friday.redis.zadd(dependencies_key, 0, dep.to_s)
    end

    def remove_dependency(dep)
      dep.remove_app(@app.id)
      Friday.redis.zrem(dependencies_key, dep.to_s)
    end
  end
end
