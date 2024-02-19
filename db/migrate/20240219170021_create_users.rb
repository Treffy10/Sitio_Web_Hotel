class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.integer :receptionistID
      t.integer :adminID
      t.string :username
      t.string :password
      t.date :creationDate

      t.timestamps
    end
  end
end
