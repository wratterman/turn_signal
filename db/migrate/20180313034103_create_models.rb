class CreateModels < ActiveRecord::Migration[5.1]
  def change
    create_table :models do |t|
      t.string :name
      t.references :make, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
