# frozen_string_literal: true

class MoveDataToEngine < ActiveRecord::Migration[6.1]
  def up
    hosts = {}
    Host.all.each do |host|
      hosts[host.domain] = Friday::Host.create!(domain: host.domain, token: host.token, type: "Friday::#{host.type}")
    end

    Repo.all.each do |repo|
      host = hosts[repo.host.domain]

      fr = Friday::Repository.create!(full_path: repo.full_path, host: host)
      Friday::Project.create!(
        repository: fr,
        name: repo.name,
        directory: repo.directory,
        package_manager: "bundler",
        language_version: repo.ruby_version
      )
    end
  end

  def down
    Friday::Project.delete_all
    Friday::Repository.delete_all
    Friday::Host.delete_all
  end
end
