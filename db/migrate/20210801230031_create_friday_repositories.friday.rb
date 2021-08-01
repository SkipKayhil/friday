# This migration comes from friday (originally 20210801225440)
class CreateFridayRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :friday_repositories do |t|
      t.string :full_path
      t.references :host, null: false, foreign_key: true

      t.timestamps
    end
  end
end
