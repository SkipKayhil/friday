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

    def initialize(app)
      @app = app
      @dependencies = fetch_and_parse_dependencies
    end

    def update(new_dependencies)
      parsed_dependencies = parse_new_dependencies(new_dependencies)

      @dependencies.each_value { |removed_dep| remove_dependency(removed_dep) }

      @dependencies = parsed_dependencies
    end

    def to_h
      @dependencies
    end

    private

    def dependencies_key
      "app:#{@app.id}:dependencies:#{@app.language}"
    end

    def fetch_and_parse_dependencies
      dependencies = Redis.current.zrange(dependencies_key, 0, -1)

      dependencies.map do |key|
        dep = Dependency.from_key(key)
        [dep.name, dep]
      end.to_h
    end

    def parse_new_dependencies(new_dependencies)
      new_dependencies.map do |dep|
        d = Dependency.new(@app.language, dep.name, dep.version)

        old_version = @dependencies.delete(d.name)

        if old_version != d
          remove_dependency(old_version) if old_version
          add_dependency(d)
        end

        [d.name, d]
      end.to_h
    end

    def add_dependency(dep)
      dep.add_app(@app.id)
      Redis.current.zadd(dependencies_key, 0, dep.to_s)
    end

    def remove_dependency(dep)
      dep.remove_app(@app.id)
      Redis.current.zrem(dependencies_key, dep.to_s)
    end
  end
end
