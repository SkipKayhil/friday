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
      .pluck(*attrs, Arel.sql(self.class.sanitize_sql_array(['dependencies -> ?', lib_name])))
      .map do |id, full_path, dep|
        { id: id, full_path: full_path }.merge!(dep)
      end
  end
end
