class CreateAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :lastnamePaternal
      t.string :lastnameMaternal
      t.string :dni
      t.string :phone
      t.string :location
      t.date :birthday
      t.string :email

      t.timestamps
    end
  end
end
