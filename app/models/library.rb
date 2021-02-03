# frozen_string_literal: true

# A Library can be a dependency of an App
class Library < ApplicationRecord
  include Repoable

  def attributes
    h = super
    h[:dependents] = dependents
    h
  end

  private

  def dependents
    attrs = %w[id full_path]

    lib_name = repo.name.presence || repo.full_path.match(%r{[^/]+$})[0]

    Repo
      .depends_on(lib_name)
      .pluck(*attrs, Arel.sql(self.class.sanitize_sql_array(["dependencies -> ? -> 'version'", lib_name])))
      .map { |pluck| (attrs + ['version']).zip(pluck).to_h }
  end
end
