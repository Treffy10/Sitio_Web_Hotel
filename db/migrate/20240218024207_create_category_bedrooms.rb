class CreateCategoryBedrooms < ActiveRecord::Migration[7.1]
  def change
    create_table :category_bedrooms do |t|
      t.string :title
      t.text :description
      t.float :priceNight
      t.integer :maxPersons
      t.string :beds

      t.timestamps
    end
  end
end
