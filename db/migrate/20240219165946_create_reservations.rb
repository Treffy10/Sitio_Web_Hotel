class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.integer :residentID
      t.integer :bedroomID
      t.integer :adminID
      t.date :dateReservation

      t.timestamps
    end
  end
end
