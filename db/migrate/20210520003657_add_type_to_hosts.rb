# frozen_string_literal: true

class AddTypeToHosts < ActiveRecord::Migration[6.1]
  def change
    add_column :hosts, :type, :string
  end
end
