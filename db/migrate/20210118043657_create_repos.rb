class CreateRepos < ActiveRecord::Migration[6.1]
  def change
    create_table :repos do |t|
      t.string :name
      t.string :full_path
      t.string :directory
      t.string :ruby_version
      t.jsonb :dependencies
      t.references :repoable, polymorphic: true
      t.belongs_to :host

      t.timestamps
    end
  end
end
