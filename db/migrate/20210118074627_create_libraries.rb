class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    create_table :libraries do |t|

      t.timestamps
    end
  end
end
