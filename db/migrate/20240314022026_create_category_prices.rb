class CreateCategoryPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :category_prices do |t|
      t.integer :ocupacion
      t.float :price
      t.float :descuento_web
      t.integer :nights

      t.timestamps
    end
  end
end
