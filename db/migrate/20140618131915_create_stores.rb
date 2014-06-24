class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :model_name
      t.string :brand
      t.string :color
      t.decimal :price
      t.text :description
      t.text :feature1
      t.text :feature2
      t.attachment :image

      t.timestamps
    end
  end
end
