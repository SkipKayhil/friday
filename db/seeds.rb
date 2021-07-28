# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
github = Host::Github.find_or_create_by(domain: 'github.com', token: ENV['GITHUB_ACCESS_TOKEN'])
gitlab = Host::Gitlab.find_or_create_by(domain: 'gitlab.com', token: ENV['GITLAB_ACCESS_TOKEN'])

apps = [
  { path: 'skipkayhil/friday', host: github },
  { path: 'discourse/discourse', host: github },
  { path: 'gitlab-org/gitlab', host: gitlab },
]
apps.each do |app|
  Repo.find_or_create_by(full_path: app[:path]) do |repo|
    repo.repoable = App.new
    repo.host = app[:host]
  end
end
