class CreateHosts < ActiveRecord::Migration[6.1]
  def change
    create_table :hosts do |t|
      t.string :domain
      t.string :token

      t.timestamps
    end
  end
end
