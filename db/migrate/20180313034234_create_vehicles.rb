class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.references :make, foreign_key: true
      t.references :model, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
