# frozen_string_literal: true

# This migration comes from friday (originally 20210803015301)
class CreateFridayProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :friday_projects do |t|
      t.string :name
      t.string :directory
      t.string :package_manager
      t.string :language_version
      t.references :repository, null: false, foreign_key: {to_table: :friday_repositories}

      t.timestamps
    end
  end
end
