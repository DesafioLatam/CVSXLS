class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :number
      t.string :name
      t.string :title

      t.timestamps null: false
    end
  end
end
