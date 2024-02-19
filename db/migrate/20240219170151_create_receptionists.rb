class CreateReceptionists < ActiveRecord::Migration[7.1]
  def change
    create_table :receptionists do |t|
      t.string :name
      t.string :lastnamePaternal
      t.string :lastnameMaternal
      t.date :birthday
      t.string :dni

      t.timestamps
    end
  end
end
