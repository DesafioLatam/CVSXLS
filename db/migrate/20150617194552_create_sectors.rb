class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :name
      t.string :code
      t.references :commune, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
