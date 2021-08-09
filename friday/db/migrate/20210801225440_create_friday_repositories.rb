# frozen_string_literal: true

class CreateFridayRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :friday_repositories do |t|
      t.string :full_path
      t.references :host, null: false, foreign_key: {to_table: :friday_hosts}

      t.timestamps
    end
  end
end
