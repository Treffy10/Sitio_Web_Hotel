class CreatePays < ActiveRecord::Migration[7.1]
  def change
    create_table :pays do |t|
      t.integer :reservationID
      t.string :paymentMethod

      t.timestamps
    end
  end
end
