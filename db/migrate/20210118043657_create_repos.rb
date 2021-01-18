class CreateRepos < ActiveRecord::Migration[6.1]
  def change
    create_table :repos do |t|
      t.string :full_path
      t.string :directory
      t.string :ruby_version
      t.jsonb :dependencies

      t.timestamps
    end
  end
end
