# frozen_string_literal: true

# This migration comes from friday (originally 20210728033940)
class CreateFridayHosts < ActiveRecord::Migration[6.1]
  def change
    create_table :friday_hosts do |t|
      t.string :domain
      t.string :token
      t.string :type

      t.timestamps
    end
  end
end
