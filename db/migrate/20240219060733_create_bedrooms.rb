class CreateBedrooms < ActiveRecord::Migration[7.1]
  def change
    create_table :bedrooms do |t|
      t.string :numberBedroom
      t.boolean :avaibility

      t.timestamps
    end
  end
end
